{
  flake.nixosModules.sonarr = {
    lib,
    config,
    ...
  }: let
    user = "sonarr";
    group = "media";
    url = "sonarr.matmoa.eu";
    port = 10018;
  in {
    sops = {
      secrets."sonarr/apikey" = {
        owner = user;
        group = group;
        mode = "0400";
      };
      templates."sonarr/template" = {
        owner = user;
        group = group;
        mode = "0400";
        content = ''
          SONARR__AUTH__APIKEY="${config.sops.placeholder."sonarr/apikey"}"
        '';
      };
    };
    services.sonarr = {
      enable = true;
      user = user;
      group = group;
      dataDir = "/var/lib/sonarr";
      environmentFiles = [config.sops.templates."sonarr/template".path];
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
