{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.boued;
  types = lib.types;
in {
  options.myModules.boued = {
    enable = lib.mkEnableOption "boued behind Caddy";

    url = lib.mkOption {
      type = types.str;
      default = "boued.matmoa.eu";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10025;
    };
  };

  config = lib.mkIf cfg.enable {
    services.boued = {
      enable = true;
      allowRegistration = false;
      port = cfg.port;
    };
    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
