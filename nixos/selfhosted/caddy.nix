{...}: {
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
        "router.matmoa.eu".extraConfig = ''
          import authelia
          reverse_proxy 192.168.1.1
        '';
      };
    };
  };
}
