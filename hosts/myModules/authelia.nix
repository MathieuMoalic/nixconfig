{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.authelia;
  types = lib.types;
in {
  options.myModules.authelia = {
    enable = lib.mkEnableOption "authelia behind Caddy";

    url = lib.mkOption {
      type = types.str;
      default = "authelia.matmoa.eu";
    };

    port = lib.mkOption {
      type = types.port;
      default = 9091;
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."authelia/encryptionKey" = {
      owner = "authelia-main";
      group = "authelia-main";
      mode = "0400";
    };

    sops.secrets."authelia/jwt_secret" = {
      owner = "authelia-main";
      group = "authelia-main";
      mode = "0400";
    };

    environment.etc."authelia/users_database.yml".text = ''
      users:
        mat:
          displayname: "mat"
          email: "mathieu@matmoa.eu"
          password: $argon2id$v=19$m=65536,t=3,p=4$wfd2DGdeySk8IqhMDtC1Rw$ficXqtumxqqmSagEFqyZ7pYbHiH2zyvFNTLAoGPbfHA
    '';

    services.authelia.instances.main = {
      enable = true;
      secrets = {
        jwtSecretFile = config.sops.secrets."authelia/jwt_secret".path;
        storageEncryptionKeyFile = config.sops.secrets."authelia/encryptionKey".path;
      };

      settings = {
        theme = "dark";

        log = {
          level = "warn";
          file_path = "/var/lib/authelia-main/logs";
        };

        server = {
          address = "127.0.0.1:${toString cfg.port}";
        };

        totp = {
          issuer = "authelia.com";
          period = 30;
          skew = 1;
        };

        authentication_backend = {
          file = {
            path = "/etc/authelia/users_database.yml";
            password = {
              algorithm = "argon2id";
              iterations = 1;
              salt_length = 16;
              parallelism = 8;
              memory = 1024; # KiB per thread
            };
          };
        };

        access_control = {
          default_policy = "one_factor";
          networks = [
            {
              name = "internal";
              networks = ["192.168.1.89/18"];
            }
          ];
          rules = [
            {
              domain = "*.matmoa.eu";
              networks = ["internal"];
              policy = "bypass";
            }
          ];
        };

        session = {
          name = "authelia_session";
          expiration = 50000000;
          inactivity = 300;

          cookies = [
            {
              domain = "matmoa.eu";
              authelia_url = "https://${cfg.url}";
            }
          ];
        };

        regulation = {
          max_retries = 3;
          find_time = 120;
          ban_time = 300;
        };

        storage = {
          local.path = "/var/lib/authelia-main/db.sqlite3";
        };

        notifier.filesystem.filename = "/var/lib/authelia-main/notification.txt";
      };
    };
    services.caddy = {
      extraConfig = ''
        (authelia) {
          forward_auth localhost:${toString cfg.port} {
            uri /api/verify?rd=https://${cfg.url}/
            copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
          }
        }
      '';
      services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
        reverse_proxy 127.0.0.1:${toString cfg.port}
      '';
    };
  };
}
