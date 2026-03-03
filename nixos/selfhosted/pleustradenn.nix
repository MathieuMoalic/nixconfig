{
  flake.nixosModules.pleustradenn = {
    lib,
    config,
    ...
  }: let
    url = "pleustradenn.matmoa.eu";
    port = 10026;
  in {
    services.pleustradenn = {
      enable = true;
      databaseUrl = "file:///var/lib/pleustradenn/prod.db";
      allowRegistration = false;
      port = port;
    };
    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
