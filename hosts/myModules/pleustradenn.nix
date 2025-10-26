{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.pleustradenn;
  types = lib.types;
in {
  options.myModules.pleustradenn = {
    enable = lib.mkEnableOption "pleustradenn behind Caddy";

    url = lib.mkOption {
      type = types.str;
      default = "pleustradenn.matmoa.eu";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10026;
    };
  };

  config = lib.mkIf cfg.enable {
    services.pleustradenn = {
      enable = true;
      databaseUrl = "file:///var/lib/pleustradenn/prod.db";
      allowRegistration = false;
      port = cfg.port;
    };
    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
