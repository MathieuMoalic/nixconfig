{...}: {
  flake.nixosModules.homepage = {
    lib,
    config,
    ...
  }: let
    url = "matmoa.eu";
    port = 10033;
  in {
    services.homepage = {
      enable = true;
      port = port;
    };

    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
