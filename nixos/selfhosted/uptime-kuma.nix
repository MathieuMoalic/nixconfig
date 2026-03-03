{...}: {
  flake.nixosModules.uptime-kuma = {
    lib,
    config,
    ...
  }: let
    url = "uptime.matmoa.eu";
    port = 10002;
  in {
    services.uptime-kuma = {
      enable = true;
      settings = {
        PORT = "${toString port}";
      };
    };
    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
