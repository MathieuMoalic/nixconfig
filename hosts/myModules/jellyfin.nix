{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.jellyfin;
  types = lib.types;
in {
  options.myModules.jellyfin = {
    enable = lib.mkEnableOption "Jellyfin behind Caddy";

    user = lib.mkOption {
      type = types.str;
      default = "jellyfin";
      description = "System user that owns Jellyfin and media files.";
    };

    group = lib.mkOption {
      type = types.str;
      default = "media";
      description = "Group for media ownership.";
    };

    url = lib.mkOption {
      type = types.str;
      default = "jellyfin.matmoa.eu";
      description = "Hostname served by Caddy.";
    };

    port = lib.mkOption {
      type = types.port;
      default = 8096;
      description = "Jellyfin port.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      user = cfg.user;
      group = cfg.group;
      logDir = "/var/lib/jellyfin/logs";
      dataDir = "/var/lib/jellyfin/data";
      configDir = "/var/lib/jellyfin/config";
      cacheDir = "/var/lib/jellyfin/cache";
    };
    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
    networking.firewall.allowedTCPPorts = [cfg.port];
  };
}
