{
  flake.nixosModules.vaultwarden = {
    lib,
    config,
    ...
  }: let
    url = "vw.matmoa.eu";
    port = 10014;
  in {
    services.vaultwarden = {
      enable = true;
      config = {
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = port;
      };
    };
    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
