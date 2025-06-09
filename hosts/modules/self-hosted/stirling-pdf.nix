{...}: let
  port = 10001;
in {
  services.caddy = {
    virtualHosts = {
      "pdf.matmoa.eu" = {
        extraConfig = ''reverse_proxy localhost:${toString port}'';
      };
    };
  };
  services.stirling-pdf = {
    enable = true;
    environment = {
      INSTALL_BOOK_AND_ADVANCED_HTML_OPS = "true";
      SERVER_PORT = port;
      METRICS_ENABLE = "false";
    };
  };
}
