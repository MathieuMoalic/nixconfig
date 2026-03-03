{...}: {
  flake.nixosModules.bazarr = {
    lib,
    config,
    ...
  }: let
    user = "bazarr";
    group = "media";
    url = "bazarr.matmoa.eu";
    port = 10019;
  in {
    sops = {
      secrets."bazarr/apikey" = {
        owner = user;
        group = group;
        mode = "0400";
      };
      templates."bazarr/template" = {
        owner = user;
        group = group;
        mode = "0400";
        content = ''
          BAZARR__AUTH__APIKEY="${config.sops.placeholder."bazarr/apikey"}"
        '';
      };
    };
    services.bazarr = {
      enable = true;
      user = user;
      group = group;
      listenPort = port;
    };
    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
