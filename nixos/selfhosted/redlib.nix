{
  flake.nixosModules.redlib = {...}: let
    url = "redlib.matmoa.eu";
    port = 10004;
  in {
    services.redlib = {
      enable = true;
      address = "127.0.0.1";
      inherit port;
    };

    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
