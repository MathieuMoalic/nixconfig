{
  flake.nixosModules.synapse = {
    lib,
    config,
    ...
  }: let
    user = "matrix-synapse";
    group = "matrix-synapse";

    url = "matrix.matmoa.eu";
    baseUrl = "https://${url}";

    port = 10007;
    synapsePortStr = toString port;
    dataDir = "/var/lib/synapse";

    turnHost = "matmoa.eu";
    turnTcpPort = 3478;
    turnTlsPort = 5349;

    udpMinPort = 49160;
    udpMaxPort = 49200;

    rtcHost = "rtc.matmoa.eu";

    livekitPort = 7880;
    livekitPortStr = toString livekitPort;

    jwtServicePort = 8788;
    jwtServicePortStr = toString jwtServicePort;

    secretMode = "0400";
    synapseSecretPerms = {
      owner = user;
      group = group;
      mode = secretMode;
    };
  in {
    ######################################################
    ###################### SOPS ##########################
    ######################################################
    sops = {
      secrets = {
        "synapse/registration_shared_secret" = synapseSecretPerms;
        "synapse/macaroon_secret_key" = synapseSecretPerms;
        "synapse/form_secret" = synapseSecretPerms;
        "synapse/turn_shared_secret" = synapseSecretPerms;

        "coturn/turn_shared_secret" = {
          key = "synapse/turn_shared_secret";
          owner = "turnserver";
          group = "turnserver";
          mode = secretMode;
        };

        "lk-jwt-service/keys" = {
          key = "livekit/keys";
          owner = "lk-jwt-service";
          group = "lk-jwt-service";
          mode = secretMode;
        };

        "livekit/keys" = {
          owner = "root";
          group = "root";
          mode = secretMode;
        };
      };

      templates."synapse/template" = {
        owner = user;
        group = group;
        mode = "0400";
        content = ''
          registration_shared_secret: "${config.sops.placeholder."synapse/registration_shared_secret"}"
          macaroon_secret_key: "${config.sops.placeholder."synapse/macaroon_secret_key"}"
          form_secret: "${config.sops.placeholder."synapse/form_secret"}"
          turn_shared_secret: "${config.sops.placeholder."synapse/turn_shared_secret"}"
        '';
      };
    };

    ######################################################
    ###################### USERS #########################
    ######################################################
    users.groups.lk-jwt-service = {};
    users.users.lk-jwt-service = {
      isSystemUser = true;
      group = "lk-jwt-service";
    };

    ######################################################
    #################### FIREWALL ########################
    ######################################################
    networking.firewall = {
      allowedTCPPorts = [80 443 turnTcpPort turnTlsPort];
      allowedUDPPorts = [turnTcpPort];
      allowedUDPPortRanges = [
        {
          from = udpMinPort;
          to = udpMaxPort;
        }
      ];
    };

    ######################################################
    ##################### SERVICES #######################
    ######################################################
    services.matrix-synapse = {
      enable = true;
      dataDir = dataDir;
      withJemalloc = true;

      extraConfigFiles = [
        config.sops.templates."synapse/template".path
      ];

      settings = {
        server_name = url;
        public_baseurl = "${baseUrl}/";

        max_upload_size = "50M";
        max_image_pixels = "50M";

        listeners = [
          {
            port = port;
            bind_addresses = ["127.0.0.1"];
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
          args = {database = "${dataDir}/homeserver.db";};
        };

        media_store_path = "${dataDir}/media_store";
        report_stats = false;

        signing_key_path = "${dataDir}/${url}.signing.key";
        trusted_key_servers = [{server_name = "matrix.org";}];
        suppress_key_server_warning = true;

        enable_registration = true;
        enable_registration_without_verification = true;

        turn_uris = [
          "turn:${turnHost}:${toString turnTcpPort}?transport=udp"
          "turn:${turnHost}:${toString turnTcpPort}?transport=tcp"
          "turns:${turnHost}:${toString turnTlsPort}?transport=tcp"
        ];
        turn_user_lifetime = "1h";
        turn_allow_guests = true;
      };
    };

    services.caddy.virtualHosts.${url}.extraConfig = ''
      encode zstd gzip

      handle /.well-known/matrix/server {
        header Content-Type application/json
        header Access-Control-Allow-Origin *
        respond `{"m.server":"${url}:443"}`
      }

      handle /.well-known/matrix/client {
        header Content-Type application/json
        header Access-Control-Allow-Origin *
        respond `{
          "m.homeserver": { "base_url": "${baseUrl}" },
          "org.matrix.msc4143.rtc_foci": [
            { "type": "livekit", "livekit_service_url": "https://${rtcHost}" }
          ]
        }`
      }

      handle_path /_matrix/* {
        reverse_proxy 127.0.0.1:${synapsePortStr}
      }

      handle_path /_synapse/client/* {
        reverse_proxy 127.0.0.1:${synapsePortStr}
      }
    '';

    services.coturn = {
      enable = true;

      use-auth-secret = true;
      static-auth-secret-file = config.sops.secrets."coturn/turn_shared_secret".path;

      realm = turnHost;

      listening-port = turnTcpPort;
      tls-listening-port = turnTlsPort;

      no-cli = true;
      no-tcp-relay = true;

      min-port = udpMinPort;
      max-port = udpMaxPort;
    };

    services.livekit = {
      enable = true;

      # You’re terminating TLS at Caddy, so you usually *don’t* want LiveKit
      # opened directly to the internet.
      openFirewall = false;

      keyFile = config.sops.secrets."livekit/keys".path;

      settings = {
        port = livekitPort;
        rtc = {
          port_range_start = udpMinPort;
          port_range_end = udpMaxPort;
          node_ip = "109.173.160.203";
        };
      };
    };

    services.lk-jwt-service = {
      enable = true;
      livekitUrl = "wss://${rtcHost}";
      keyFile = config.sops.secrets."lk-jwt-service/keys".path;
      port = jwtServicePort;
    };

    services.caddy.virtualHosts.${rtcHost}.extraConfig = ''
      encode zstd gzip

      # JWT / token service
      @jwt path /sfu/get* /token* /livekit-jwt* /livekit-jwt-service*
      handle @jwt {
        reverse_proxy 127.0.0.1:${jwtServicePortStr}
      }

      # LiveKit WebSockets + API
      handle {
        reverse_proxy 127.0.0.1:${livekitPortStr}
      }
    '';
  };
}
