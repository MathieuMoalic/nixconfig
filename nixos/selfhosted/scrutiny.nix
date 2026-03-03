{...}: {
  flake.nixosModules.scrutiny = {
    lib,
    config,
    ...
  }: let
    url = "scrutiny.matmoa.eu";
    port = 10042;
  in {
    services.systembus-notify.enable = lib.mkForce true;
    services.scrutiny = {
      enable = true;
      settings.web.listen.port = port;
    };
    services.caddy.virtualHosts.${url}.extraConfig = ''
      import authelia
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
