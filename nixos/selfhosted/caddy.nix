{
  flake.nixosModules.caddy = {
    lib,
    config,
    ...
  }: {
    networking = {
      firewall = {
        enable = true;
        allowedTCPPorts = [80 443];
      };
    };
    services.caddy = {
      enable = true;
      virtualHosts = {
        "files.matmoa.eu".extraConfig = ''
          root * /srv/public
          file_server browse
        '';
        "defence.matmoa.eu".extraConfig = ''
          root * /srv/defence
          header {
              Content-Type "application/pdf"
              Content-Disposition "inline; filename=\"defence.pdf\""
              X-Content-Type-Options "nosniff"
          }

          rewrite * /defence.pdf
          file_server
        '';
        "defence-html.matmoa.eu".extraConfig = ''
          root * /srv/defence
          header {
              Content-Disposition "inline; filename=\"defence.html\""
              X-Content-Type-Options "nosniff"
          }

          rewrite * /defence.html
          file_server
        '';
        "router.matmoa.eu".extraConfig = ''
          import authelia
          reverse_proxy 192.168.1.1
        '';
      };
    };
  };
}
