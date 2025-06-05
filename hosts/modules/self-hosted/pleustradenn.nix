{...}: let
  port = 10026;
in {
  services.caddy = {
    virtualHosts = {
      "pleustradenn.matmoa.eu" = {
        extraConfig = ''reverse_proxy localhost:${toString port}'';
      };
    };
  };
  services.pleustradenn = {
    enable = true;
    databaseUrl = "file:///var/lib/pleustradenn/prod.db";
    allowRegistration = false;
    port = port;
  };
}
