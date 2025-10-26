{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.stirling-pdf;
  types = lib.types;
in {
  options.myModules.stirling-pdf = {
    enable = lib.mkEnableOption "stirling-pdf behind Caddy";

    url = lib.mkOption {
      type = types.str;
      default = "pdf.matmoa.eu";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10001;
    };
  };

  config = lib.mkIf cfg.enable {
    services.stirling-pdf = {
      enable = true;
      environment = {
        INSTALL_BOOK_AND_ADVANCED_HTML_OPS = "true";
        SERVER_PORT = cfg.port;
        METRICS_ENABLE = "false";
      };
    };
    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
