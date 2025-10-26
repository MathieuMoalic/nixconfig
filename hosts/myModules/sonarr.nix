{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.sonarr;
  types = lib.types;
in {
  options.myModules.sonarr = {
    enable = lib.mkEnableOption "Sonnar behind Caddy";

    user = lib.mkOption {
      type = types.str;
      default = "sonarr";
      description = "System user that owns Sonarr and media files.";
    };

    group = lib.mkOption {
      type = types.str;
      default = "media";
      description = "Group for media ownership.";
    };

    url = lib.mkOption {
      type = types.str;
      default = "sonarr.matmoa.eu";
      description = "Hostname served by Caddy.";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10018;
      description = "Sonarr port.";
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      secrets."sonarr/apikey" = {
        owner = cfg.user;
        group = cfg.group;
        mode = "0400";
      };
      templates."sonarr/template" = {
        owner = cfg.user;
        group = cfg.group;
        mode = "0400";
        content = ''
          SONARR__AUTH__APIKEY="${config.sops.placeholder."sonarr/apikey"}"
        '';
      };
    };
    services.sonarr = {
      enable = true;
      user = cfg.user;
      group = cfg.group;
      dataDir = "/var/lib/sonarr";
      environmentFiles = [config.sops.templates."sonarr/template".path];
      settings = {
        log = {
          analyticsEnabled = false;
          level = "info";
        };
        server = {
          bindaddress = "*";
          port = cfg.port;
        };

        update = {
          mechanism = "external";
          automatically = false;
        };
      };
    };
    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
