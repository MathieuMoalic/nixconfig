{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.blaz;
  types = lib.types;
in {
  options.myModules.blaz = {
    enable = lib.mkEnableOption "blaz behind Caddy";

    url = lib.mkOption {
      type = types.str;
      default = "blaz.matmoa.eu";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10024;
    };

    logFile = lib.mkOption {
      type = types.str;
      default = "/var/log/blaz/blaz.log";
    };

    databasePath = lib.mkOption {
      type = types.str;
      default = "/var/lib/blaz/blaz.sqlite";
    };

    mediaDir = lib.mkOption {
      type = types.str;
      default = "/var/lib/blaz/media";
    };

    verbosity = lib.mkOption {
      type = types.int;
      default = 0;
      description = "Log verbosity (-2 to 3, where 0 is info)";
    };
  };

  config = lib.mkIf cfg.enable {
    services.blaz = {
      enable = true;
      bindAddr = "127.0.0.1:${toString cfg.port}";
      corsOrigin = "https://${cfg.url}";
      databasePath = cfg.databasePath;
      mediaDir = cfg.mediaDir;
      logFile = cfg.logFile;
      verbosity = cfg.verbosity;
    };
    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
