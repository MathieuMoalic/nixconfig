{
  flake.nixosModules.gpx2img = {
    config,
    inputs,
    pkgs,
    ...
  }: let
    url = "gpx2img.matmoa.eu";
    port = 10011;
    bindAddr = "127.0.0.1:${toString port}";
  in {
    services.gpx2img = {
      enable = true;
      inherit port;
    };

    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy ${bindAddr}
    '';
  };
}
