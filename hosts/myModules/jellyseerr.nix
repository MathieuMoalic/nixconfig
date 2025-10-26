{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.jellyseerr;
  types = lib.types;
in {
  options.myModules.jellyseerr = {
    enable = lib.mkEnableOption "Jellyseerr behind Caddy";

    user = lib.mkOption {
      type = types.str;
      default = "jellyseerr";
      description = "System user that owns Jellyseerr and media files.";
    };

    group = lib.mkOption {
      type = types.str;
      default = "media";
      description = "Group for media ownership.";
    };

    url = lib.mkOption {
      type = types.str;
      default = "jellyseerr.matmoa.eu";
      description = "Hostname served by Caddy.";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10023;
      description = "Jellyseerr port.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyseerr = {
      enable = true;
      # user = cfg.user;
      # group = cfg.group;
      port = cfg.port;
      configDir = "/var/lib/jellyseerr";
    };
    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
