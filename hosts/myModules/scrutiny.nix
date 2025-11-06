{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.scrutiny;
  types = lib.types;
in {
  options.myModules.scrutiny = {
    enable = lib.mkEnableOption "scrutiny behind Caddy";

    url = lib.mkOption {
      type = types.str;
      default = "scrutiny.matmoa.eu";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10042;
    };
  };

  config = lib.mkIf cfg.enable {
    services.systembus-notify.enable = lib.mkForce true;
    services.scrutiny = {
      enable = true;
      settings.web.listen.port = cfg.port;
    };
    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      import authelia
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
