{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.vaultwarden;
  types = lib.types;
in {
  options.myModules.vaultwarden = {
    enable = lib.mkEnableOption "Vaulwarden behind Caddy";

    url = lib.mkOption {
      type = types.str;
      default = "vw.matmoa.eu";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10014;
    };
  };

  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      config = {
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = cfg.port;
      };
    };
    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
