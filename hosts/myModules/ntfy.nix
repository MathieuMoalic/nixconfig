{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.ntfy;
  types = lib.types;
in {
  options.myModules.ntfy = {
    enable = lib.mkEnableOption "ntfy behind Caddy";

    url = lib.mkOption {
      type = types.str;
      default = "ntfy.matmoa.eu";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10013;
    };
  };

  config = lib.mkIf cfg.enable {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://ntfy.matmoa.eu";
        listen-http = ":${toString cfg.port}";
      };
    };
    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
