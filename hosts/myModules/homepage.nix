{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.homepage;
  types = lib.types;
in {
  options.myModules.homepage = {
    enable = lib.mkEnableOption "homepage behind Caddy";

    url = lib.mkOption {
      type = types.str;
      default = "matmoa.eu";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10033;
    };
  };

  config = lib.mkIf cfg.enable {
    services.homepage = {
      enable = true;
      port = cfg.port;
    };

    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
