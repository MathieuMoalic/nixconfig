{...}: let
  port = 10033;
in {
  services.caddy = {
    virtualHosts = {
      "matmoa.xyz" = {
        extraConfig = ''redir https://matmoa.eu permanent'';
      };
      "matmoa.eu" = {
        extraConfig = ''reverse_proxy localhost:${toString port}'';
      };
    };
  };
  services.homepage = {
    enable = true;
    port = port;
  };
}
