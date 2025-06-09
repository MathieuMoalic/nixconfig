{...}: let
  port = 10014;
in {
  services.caddy = {
    virtualHosts = {
      "vw.matmoa.eu" = {
        extraConfig = ''reverse_proxy localhost:${toString port}'';
      };
    };
  };
  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = port;
    };
  };
}
