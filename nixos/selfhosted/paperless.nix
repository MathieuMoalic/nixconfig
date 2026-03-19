{
  flake.nixosModules.paperless = {
    pkgs,
    lib,
    config,
    ...
  }: let
    user = "paperless";
    url = "paperless.matmoa.eu";
    port = 10003;

    dataDir = "/var/lib/paperless";
    mediaDir = "${dataDir}/media";
    consumeDir = "${dataDir}/consume";
    exportDir = "${dataDir}/export";
  in {
    sops = {
      secrets."paperless/admin-password" = {
        owner = user;
        group = user;
        mode = "0400";
      };

      secrets."paperless/secret-key" = {
        owner = user;
        group = user;
        mode = "0400";
      };

      templates."paperless/environment" = {
        owner = user;
        group = user;
        mode = "0400";
        content = ''
          PAPERLESS_SECRET_KEY="${config.sops.placeholder."paperless/secret-key"}"
        '';
      };
    };
    services = {
      gotenberg = {
        enable = true;
        port = 10004;
      };
      tika.enable = true;
      paperless = {
        enable = true;
        package = pkgs.paperless-ngx;

        user = user;

        address = "127.0.0.1";
        port = port;
        domain = url;

        dataDir = dataDir;
        mediaDir = mediaDir;
        consumptionDir = consumeDir;
        consumptionDirIsPublic = false;

        passwordFile = config.sops.secrets."paperless/admin-password".path;
        environmentFile = config.sops.templates."paperless/environment".path;

        database.createLocally = true;

        configureNginx = false;
        configureTika = false;

        settings = {
          PAPERLESS_TIKA_ENABLED = "1";
          PAPERLESS_TIKA_GOTENBERG_ENDPOINT = "http://127.0.0.1:3010";
          PAPERLESS_TIKA_ENDPOINT = "http://127.0.0.1:9998";
        };

        openMPThreadingWorkaround = true;

        settings = {
          PAPERLESS_URL = "https://${url}";
          PAPERLESS_TIME_ZONE = "Europe/Warsaw";
          PAPERLESS_OCR_LANGUAGE = "eng+pol+fra";
          PAPERLESS_ACCOUNT_ALLOW_SIGNUPS = false;
          PAPERLESS_ADMIN_USER = "admin";
          PAPERLESS_CONSUMER_POLLING = 60;
        };

        exporter = {
          enable = true;
          onCalendar = "daily";
          directory = exportDir;
          settings = {
            compression = false;
          };
        };
      };

      caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy 127.0.0.1:${toString port}
      '';
    };
  };
}
