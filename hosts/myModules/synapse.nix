{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.synapse;
  inherit (lib) mkOption mkIf;
  types = lib.types;
in {
  options.myModules.synapse = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Matrix Synapse + TURN + LiveKit setup.";
    };

    user = mkOption {
      type = types.str;
      default = "matrix-synapse";
      description = "System user for Synapse.";
    };

    group = mkOption {
      type = types.str;
      default = "matrix-synapse";
      description = "System group for Synapse.";
    };

    url = mkOption {
      type = types.str;
      default = "matrix.matmoa.eu";
      description = "Public Matrix homeserver URL (hostname).";
    };

    port = mkOption {
      type = types.port;
      default = 10007;
      description = "HTTP port Synapse listens on.";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/synapse";
      description = "Data directory for Synapse.";
    };

    turnTcpPort = mkOption {
      type = types.port;
      default = 3478;
      description = "Plain TURN (TCP/UDP) listening port.";
    };

    turnTlsPort = mkOption {
      type = types.port;
      default = 5349;
      description = "TLS TURN listening port.";
    };

    turnUdpMinPort = mkOption {
      type = types.port;
      default = 49160;
      description = "Start of UDP port range for TURN/WebRTC.";
    };

    turnUdpMaxPort = mkOption {
      type = types.port;
      default = 49200;
      description = "End of UDP port range for TURN/WebRTC.";
    };

    livekitPort = mkOption {
      type = types.port;
      default = 7880;
      description = "LiveKit SFU TCP port.";
    };

    jwtServicePort = mkOption {
      type = types.port;
      default = 8788;
      description = "MatrixRTC JWT service port.";
    };
  };

  config = mkIf cfg.enable (
    let
      baseUrl = "https://${cfg.url}";
      synapsePortStr = toString cfg.port;
      livekitPortStr = toString cfg.livekitPort;
      jwtServicePortStr = toString cfg.jwtServicePort;

      turnTcpPort = cfg.turnTcpPort;
      turnTlsPort = cfg.turnTlsPort;
      udpMinPort = cfg.turnUdpMinPort;
      udpMaxPort = cfg.turnUdpMaxPort;

      turnHost = "matmoa.eu";
      rtcHost = "rtc.matmoa.eu";

      synapseSecretPerms = {
        owner = cfg.user;
        group = cfg.group;
        mode = "0400";
      };

      secretMode = "0400";
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

      ######################################################
      ###################### USERS #########################
      ######################################################
      users = {
        groups.lk-jwt-service = {};
        users.lk-jwt-service = {
          isSystemUser = true;
          group = "lk-jwt-service";
        };
      };

      ######################################################
      #################### FIREWALL ########################
      ######################################################
      networking.firewall = {
        allowedTCPPorts = [80 443 turnTcpPort turnTlsPort];
        allowedUDPPorts = [turnTcpPort turnTlsPort];
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
      services = {
        #################### SYNAPSE #######################
        matrix-synapse = {
          enable = true;
          dataDir = cfg.dataDir;
          withJemalloc = true;

          extraConfigFiles = [config.sops.templates."synapse/template".path];

          settings = {
            server_name = cfg.url;
            public_baseurl = "${baseUrl}/";
            max_upload_size = "50M";
            max_image_pixels = "50M";

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
            suppress_key_server_warning = true;

            enable_registration = true;
            enable_registration_without_verification = true;

            turn_uris = [
              "turns:${turnHost}:${toString turnTlsPort}?transport=tcp"
              "turns:${turnHost}:${toString turnTlsPort}?transport=udp"
              "turn:${turnHost}:${toString turnTcpPort}?transport=tcp"
              "turn:${turnHost}:${toString turnTcpPort}?transport=udp"
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
              "m.homeserver": { "base_url": "${baseUrl}" },
              "org.matrix.msc4143.rtc_foci": [
                {
                  "type": "livekit",
                  "livekit_service_url": "https://${rtcHost}"
                }
              ]
            }`

            reverse_proxy /_matrix/*           localhost:${synapsePortStr}
            reverse_proxy /_synapse/client/*   localhost:${synapsePortStr}
            reverse_proxy                      localhost:${synapsePortStr}
          '';
        };

        #################### COTURN ########################
        coturn = {
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

        #################### LIVEKIT #######################
        livekit = {
          enable = true;
          openFirewall = true;
          keyFile = config.sops.secrets."livekit/keys".path;

          settings = {
            port = cfg.livekitPort;

            rtc = {
              port_range_start = udpMinPort;
              port_range_end = udpMaxPort;
              node_ip = "109.173.160.203";
            };
          };
        };

        ################# LK-JWT-SERVICE ###################
        lk-jwt-service = {
          enable = true;
          livekitUrl = "wss://${rtcHost}";
          keyFile = config.sops.secrets."lk-jwt-service/keys".path;
          port = cfg.jwtServicePort;
        };

        ################ CADDY (rtc / LiveKit) ############
        caddy.virtualHosts.${rtcHost}.extraConfig = ''
          encode zstd gzip

          # JWT / token service
          @jwt path /sfu/get* /token* /livekit-jwt* /livekit-jwt-service*
          reverse_proxy @jwt 127.0.0.1:${jwtServicePortStr}

          # LiveKit WebSockets + API
          reverse_proxy 127.0.0.1:${livekitPortStr}
        '';
      };
    }
  );
}
