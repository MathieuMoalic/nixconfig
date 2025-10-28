{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.synapse;
  types = lib.types;
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
    services.matrix-synapse = {
      enable = true;
      dataDir = "${cfg.dataDir}";
      withJemalloc = true;

      extraConfigFiles = [config.sops.templates."synapse/template".path];

      settings = {
        server_name = cfg.url;

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

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 matrix-synapse matrix-synapse -"
    ];
    services.caddy.virtualHosts.${cfg.url} = {
      extraConfig = ''

        header /.well-known/matrix/* Content-Type application/json
        header /.well-known/matrix/* Access-Control-Allow-Origin *
        respond /.well-known/matrix/server  `{"m.server": "${cfg.url}:443"}`
        respond /.well-known/matrix/client  `{"m.homeserver":{"base_url":"https://${cfg.url}"}}`

        reverse_proxy /_matrix/*           localhost:${toString cfg.port}
        reverse_proxy /_synapse/client/*   localhost:${toString cfg.port}
        reverse_proxy                      localhost:${toString cfg.port}
      '';
    };
  };
}
