{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.bazarr;
  types = lib.types;
in {
  options.myModules.bazarr = {
    enable = lib.mkEnableOption "Bazarr behind Caddy";

    user = lib.mkOption {
      type = types.str;
      default = "bazarr";
      description = "System user that owns Bazarr and media files.";
    };

    group = lib.mkOption {
      type = types.str;
      default = "media";
      description = "Group for media ownership.";
    };

    url = lib.mkOption {
      type = types.str;
      default = "bazarr.matmoa.eu";
      description = "Hostname served by Caddy.";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10019;
      description = "Bazarr port.";
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      secrets."bazarr/apikey" = {
        owner = cfg.user;
        group = cfg.group;
        mode = "0400";
      };
      templates."bazarr/template" = {
        owner = cfg.user;
        group = cfg.group;
        mode = "0400";
        content = ''
          BAZARR__AUTH__APIKEY="${config.sops.placeholder."bazarr/apikey"}"
        '';
      };
    };
    services.bazarr = {
      enable = true;
      user = cfg.user;
      group = cfg.group;
      listenPort = cfg.port;
      # dataDir = "/var/lib/bazarr";
      # environmentFiles = [config.sops.templates."bazarr/template".path];
      # settings = {
      #   log = {
      #     analyticsEnabled = false;
      #     level = "info";
      #   };
      #   server = {
      #     bindaddress = "*";
      #     port = cfg.port;
      #   };
      #
      #   update = {
      #     mechanism = "external";
      #     automatically = false;
      #   };
      # };
    };
    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
