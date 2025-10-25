{
  pkgs,
  config,
  ...
}: let
  mqttUser = "owntracks";
  mqttPort = 10031;
in {
  services.caddy = {
    virtualHosts = {
      "owntracks.matmoa.eu" = {
        extraConfig = ''
          import authelia
          reverse_proxy localhost:8083
          encode gzip zstd
        '';
      };

      "mqtt.matmoa.eu" = {
        extraConfig = ''
          @ws {
            header Connection *Upgrade*
            header Upgrade    websocket
          }

          reverse_proxy @ws localhost:${toString mqttPort} {
            # make sure Caddy speaks HTTP/1.1 to Mosquitto
            transport http {
              versions 1.1
            }
            # pass the upgrade headers through unchanged
            header_up Host       {host}
            header_up Connection {http.request.header.Connection}
            header_up Upgrade    {http.request.header.Upgrade}
          }

          log {
            output file /var/log/caddy/mqtt_ws_access.log
          }
        '';
      };

      "owntracks-frontend.matmoa.eu" = {
        extraConfig = ''
          import authelia
          reverse_proxy localhost:10032
        '';
      };
    };
  };
  sops.secrets."owntracks/password" = {
    owner = "mat";
    group = "mat";
    mode = "0400";
  };
  services.owntracks-frontend = {
    enable = true;
    apiBaseUrl = "https://owntracks.matmoa.eu";
  };
  services.mosquitto = {
    enable = true;
    package = pkgs.mosquitto;
    persistence = true;
    dataDir = "/var/lib/mosquitto";
    logType = ["error" "warning" "notice" "information"];
    logDest = ["syslog"];

    listeners = [
      {
        address = "127.0.0.1";
        port = 1883;
        omitPasswordAuth = false;
        settings = {
          allow_anonymous = false;
        };
        users."${mqttUser}" = {
          passwordFile = config.sops.secrets."owntracks/password".path;
          acl = ["readwrite owntracks/#"];
        };
      }
      {
        address = "127.0.0.1";
        port = mqttPort;
        omitPasswordAuth = false;
        settings = {
          allow_anonymous = false;
          protocol = "websockets";
        };

        users = {
          "${mqttUser}" = {
            passwordFile = config.sops.secrets."owntracks/password".path;
            acl = [
              "readwrite owntracks/#"
            ];
          };
        };
      }
    ];
  };
  users.groups.owntracks = {};
  users.users.owntracks = {
    isSystemUser = true;
    group = "owntracks";
    description = "OwnTracks Recorder service user";
  };

  # Create Recorder data directory with safe perms
  systemd.tmpfiles.rules = [
    "d /var/spool/owntracks 0750 owntracks owntracks -"
  ];

  sops.templates."owntracks-recorder.env" = {
    # Only the runtime *rendered* file is readable by the service user
    owner = "owntracks";
    group = "owntracks";
    mode = "0400";
    content = ''
      OTR_HOST=127.0.0.1
      OTR_PORT=1883
      OTR_TOPICS=owntracks/#
      OTR_USER=${mqttUser}
      OTR_PASS=${config.sops.placeholder."owntracks/password"}
    '';
  };

  systemd.services.owntracks-recorder = {
    description = "OwnTracks Recorder (connects to local Mosquitto)";
    requires = ["mosquitto.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      User = "owntracks";
      Group = "owntracks";
      WorkingDirectory = "/var/spool/owntracks";
      EnvironmentFile =
        config.sops.templates."owntracks-recorder.env".path;

      ExecStart = "${pkgs.owntracks-recorder}/bin/ot-recorder";
      Restart = "always";
      RestartSec = 2;
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ReadWritePaths = ["/var/spool/owntracks"];
      AmbientCapabilities = "";
      CapabilityBoundingSet = "";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictSUIDSGID = true;
      RestrictRealtime = true;
      RestrictNamespaces = true;
      SystemCallFilter = ["@system-service"];
    };
  };
}
