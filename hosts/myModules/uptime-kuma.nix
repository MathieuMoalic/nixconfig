{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.uptime;
  types = lib.types;
in {
  options.myModules.uptime = {
    enable = lib.mkEnableOption "uptime behind Caddy";

    url = lib.mkOption {
      type = types.str;
      default = "uptime.matmoa.eu";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10002;
    };
  };

  config = lib.mkIf cfg.enable {
    services.uptime-kuma = {
      enable = true;
      settings = {
        PORT = "${toString cfg.port}";
      };
    };
    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
