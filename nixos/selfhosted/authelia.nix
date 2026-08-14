{
  flake.nixosModules.authelia = {config, ...}: let
    url = "authelia.matmoa.eu";
    port = 9091;

    user = "authelia-main";
    group = "authelia-main";
  in {
    sops = {
      secrets = {
        "authelia/encryptionKey" = {
          owner = user;
          group = group;
          mode = "0400";
        };

        "authelia/jwt_secret" = {
          owner = user;
          group = group;
          mode = "0400";
        };

        "authelia/password_hash" = {
          owner = user;
          group = group;
          mode = "0400";
        };
      };

      templates."authelia/users_database.yml" = {
        owner = user;
        group = group;
        mode = "0400";

        content = ''
          users:
            mat:
              disabled: false
              displayname: "Mathieu"
              password: "${config.sops.placeholder."authelia/password_hash"}"
              email: "mathieu@matmoa.eu"
              groups:
                - admins
        '';
      };
    };

    services.authelia.instances.main = {
      enable = true;

      secrets = {
        jwtSecretFile =
          config.sops.secrets."authelia/jwt_secret".path;

        storageEncryptionKeyFile =
          config.sops.secrets."authelia/encryptionKey".path;
      };

      settings = {
        theme = "dark";
        default_2fa_method = "totp";

        server = {
          address = "tcp://127.0.0.1:${toString port}/";
        };

        log = {
          level = "warn";
          format = "text";
        };

        authentication_backend = {
          # The user database is generated declaratively by SOPS,
          # so don't let Authelia try to modify it.
          password_reset.disable = true;
          password_change.disable = true;

          file = {
            path =
              config.sops.templates."authelia/users_database.yml".path;

            watch = false;

            password = {
              algorithm = "argon2";

              argon2 = {
                variant = "argon2id";
                iterations = 3;
                memory = 65536;
                parallelism = 4;
                key_length = 32;
                salt_length = 16;
              };
            };
          };
        };

        access_control = {
          default_policy = "deny";

          rules = [
            {
              domain = "*.matmoa.eu";
              policy = "two_factor";
            }
          ];
        };

        session = {
          name = "authelia_session";
          same_site = "lax";

          inactivity = "30m";
          expiration = "8h";
          remember_me = "30d";

          cookies = [
            {
              domain = "matmoa.eu";
              authelia_url = "https://${url}";
            }
          ];
        };

        totp = {
          issuer = "matmoa.eu";
          algorithm = "sha1";
          digits = 6;
          period = 30;
          skew = 1;
          secret_size = 32;
        };

        regulation = {
          modes = ["ip"];
          max_retries = 3;
          find_time = "2m";
          ban_time = "15m";
        };

        storage = {
          local.path = "/var/lib/authelia-main/db.sqlite3";
        };

        notifier = {
          filesystem.filename = "/var/lib/authelia-main/notification.txt";
        };
      };
    };

    services.caddy = {
      extraConfig = ''
        (authelia) {
          forward_auth 127.0.0.1:${toString port} {
            uri /api/authz/forward-auth
            copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
          }
        }
      '';

      virtualHosts.${url}.extraConfig = ''
        reverse_proxy 127.0.0.1:${toString port}
      '';
    };
  };
}
