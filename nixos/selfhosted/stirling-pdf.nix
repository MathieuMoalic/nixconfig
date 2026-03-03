{...}: {
  flake.nixosModules.stirling-pdf = {
    lib,
    config,
    ...
  }: let
    url = "pdf.matmoa.eu";
    port = 10001;
  in {
    services.stirling-pdf = {
      enable = true;
      environment = {
        INSTALL_BOOK_AND_ADVANCED_HTML_OPS = "true";
        SERVER_PORT = port;
        METRICS_ENABLE = "false";
      };
    };
    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
