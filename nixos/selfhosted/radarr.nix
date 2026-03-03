{
  flake.nixosModules.radarr = {
    lib,
    config,
    ...
  }: let
    user = "radarr";
    group = "media";
    url = "radarr.matmoa.eu";
    port = 10017;
  in {
    sops = {
      secrets."radarr/apikey" = {
        owner = user;
        group = group;
        mode = "0400";
      };
      templates."radarr/template" = {
        owner = user;
        group = group;
        mode = "0400";
        content = ''
          RADARR__AUTH__APIKEY="${config.sops.placeholder."radarr/apikey"}"
        '';
      };
    };
    services.radarr = {
      enable = true;
      user = user;
      group = group;
      dataDir = "/var/lib/radarr";
      environmentFiles = [config.sops.templates."radarr/template".path];
      settings = {
        log = {
          analyticsEnabled = false;
          level = "info";
        };
        server = {
          bindaddress = "*";
          port = port;
        };

        update = {
          mechanism = "external";
          automatically = false;
        };
      };
    };
    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
