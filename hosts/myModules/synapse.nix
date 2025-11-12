{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.synapse;
  types = lib.types;
  lkPort = 7880;
in {
  options.myModules.synapse = {
    enable = lib.mkOption {
      type = types.bool;
      default = false;
    };
    user = lib.mkOption {
      type = types.str;
      default = "matrix-synapse";
    };

    group = lib.mkOption {
      type = types.str;
      default = "matrix-synapse";
    };

    url = lib.mkOption {
      type = types.str;
      default = "matrix.matmoa.eu";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10007;
    };

    dataDir = lib.mkOption {
      type = types.path;
      default = "/var/lib/synapse";
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      secrets."synapse/registration_shared_secret" = {
        owner = cfg.user;
        group = cfg.group;
        mode = "0400";
      };
      secrets."synapse/macaroon_secret_key" = {
        owner = cfg.user;
        group = cfg.group;
        mode = "0400";
      };
      secrets."synapse/form_secret" = {
        owner = cfg.user;
        group = cfg.group;
        mode = "0400";
      };
      secrets."synapse/turn_shared_secret" = {
        owner = cfg.user;
        group = cfg.group;
        mode = "0400";
      };
      templates."synapse/template" = {
        owner = cfg.user;
        group = cfg.group;
        mode = "0400";
        content = ''
          registration_shared_secret: "${config.sops.placeholder."synapse/registration_shared_secret"}"
          macaroon_secret_key: "${config.sops.placeholder."synapse/macaroon_secret_key"}"
          form_secret: "${config.sops.placeholder."synapse/form_secret"}"
          turn_shared_secret: "${config.sops.placeholder."synapse/turn_shared_secret"}"
        '';
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 matrix-synapse matrix-synapse -"
      "d ${cfg.dataDir}/media_store 0750 matrix-synapse matrix-synapse -"
    ];
    services = {
      matrix-synapse = {
        enable = true;
        dataDir = "${cfg.dataDir}";
        withJemalloc = true;

        extraConfigFiles = [config.sops.templates."synapse/template".path];

        settings = {
          server_name = cfg.url;
          public_baseurl = "https://${cfg.url}/";
          max_upload_size = "50M"; # default is ~10M, this raises Element’s limit
          max_image_pixels = "50M"; # default ~32M; huge photos can exceed it

          listeners = [
            {
              port = cfg.port;
              tls = false;
              type = "http";
              x_forwarded = true;
              resources = [
                {
                  names = ["client" "federation"];
                  compress = false;
                }
              ];
            }
          ];

          database = {
            name = "sqlite3";
            args = {database = "${cfg.dataDir}/homeserver.db";};
          };

          log_config = "${cfg.dataDir}/${cfg.url}.log.config";
          media_store_path = "${cfg.dataDir}/media_store";
          report_stats = false;
          signing_key_path = "${cfg.dataDir}/${cfg.url}.signing.key";
          trusted_key_servers = [{server_name = "matrix.org";}];

          enable_registration = true;
          enable_registration_without_verification = true;

          turn_uris = [
            "turns:matmoa.eu:5349?transport=tcp"
            "turns:matmoa.eu:5349?transport=udp"
            "turn:matmoa.eu:3478?transport=tcp"
            "turn:matmoa.eu:3478?transport=udp"
          ];
          turn_user_lifetime = "1h";
          turn_allow_guests = true;
        };
      };
      caddy.virtualHosts.${cfg.url} = {
        extraConfig = ''
          header /.well-known/matrix/* Content-Type application/json
          header /.well-known/matrix/* Access-Control-Allow-Origin *

          respond /.well-known/matrix/server `{"m.server":"${cfg.url}:443"}`
          respond /.well-known/matrix/client `{
            "m.homeserver": { "base_url": "https://${cfg.url}" },
            "org.matrix.msc4143.rtc_foci": [
              {
                "type": "livekit",
                "livekit_service_url": "https://rtc.matmoa.eu"
              }
            ]
          }`

          reverse_proxy /_matrix/*           localhost:${toString cfg.port}
          reverse_proxy /_synapse/client/*   localhost:${toString cfg.port}
          reverse_proxy                      localhost:${toString cfg.port}
        '';
      };
    };

    ######################################################
    #################### LIVEKIT #########################
    ######################################################

    sops.secrets."livekit/keys" = {
      mode = "0400";
      owner = "root";
      group = "root";
    };

    services = {
      livekit = {
        enable = true;
        openFirewall = true; # opens the UDP range & lkPort below
        keyFile = config.sops.secrets."livekit/keys".path;

        # This is the JSON config (the module turns it into livekit.json)
        settings = {
          port = lkPort;

          # WebRTC UDP ports – match your infra; these work well and are small.
          rtc = {
            port_range_start = 49160;
            port_range_end = 49200;
            use_external_ip = true; # discover public IP (good behind NAT)
          };

          # OPTIONAL: if you have a public TURN you want LK to tell clients about:
          # turn = {
          #   enabled = true;
          #   # LiveKit expects 'turn' servers here if you want LK-issued TURN creds.
          # };
        };
      };

      ## --- MatrixRTC JWT/Authorization service ---
      # This module issues JWTs for LiveKit using the SAME keyFile as above.
      lk-jwt-service = {
        enable = true;
        livekitUrl = "wss://rtc.matmoa.eu";
        keyFile = config.sops.secrets."livekit/keys".path;
        # If your module exposes a port option and it differs from 8788, adjust below.
        port = 8788;
      };

      caddy.virtualHosts."rtc.matmoa.eu".extraConfig = ''
        encode zstd gzip

        @jwt path /token* /livekit-jwt* /livekit-jwt-service*
        reverse_proxy @jwt 127.0.0.1:8788

        reverse_proxy 127.0.0.1:${toString lkPort}
      '';
    };
    # networking.firewall = {
    #   # coturn: 3478 5349 49160-49200/udp
    #   allowedTCPPorts = [3478 5349];
    #   allowedUDPPorts = [7359 3478 5349] ++ (map (x: x) (builtins.genList (x: 49160 + x) (49200 - 49160 + 1)));
    # };
  };
}
