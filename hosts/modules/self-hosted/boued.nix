{...}: let
  port = 10033;
in {
  services.caddy = {
    virtualHosts = {
      "boued.matmoa.eu" = {
        extraConfig = ''
          reverse_proxy localhost:${toString port}
        '';
      };
    };
  };
  services.boued = {
    enable = true;
    port = port;
  };
}
