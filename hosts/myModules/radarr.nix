{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.radarr;
  types = lib.types;
in {
  options.myModules.radarr = {
    enable = lib.mkEnableOption "Radarr behind Caddy";

    user = lib.mkOption {
      type = types.str;
      default = "radarr";
      description = "System user that owns Radarr and media files.";
    };

    group = lib.mkOption {
      type = types.str;
      default = "media";
      description = "Group for media ownership.";
    };

    url = lib.mkOption {
      type = types.str;
      default = "radarr.matmoa.eu";
      description = "Hostname served by Caddy.";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10017;
      description = "Radarr port.";
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      secrets."radarr/apikey" = {
        owner = cfg.user;
        group = cfg.group;
        mode = "0400";
      };
      templates."radarr/template" = {
        owner = cfg.user;
        group = cfg.group;
        mode = "0400";
        content = ''
          RADARR__AUTH__APIKEY="${config.sops.placeholder."radarr/apikey"}"
        '';
      };
    };
    services.radarr = {
      enable = true;
      user = cfg.user;
      group = cfg.group;
      dataDir = "/var/lib/radarr";
      environmentFiles = [config.sops.templates."radarr/template".path];
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
