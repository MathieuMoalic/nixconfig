{...}: {
  flake.nixosModules.jellyfin = {
    lib,
    config,
    ...
  }: let
    user = "jellyfin";
    group = "media";
    url = "jellyfin.matmoa.eu";
    port = 8096;
  in {
    services.jellyfin = {
      enable = true;
      user = user;
      group = group;
      logDir = "/var/lib/jellyfin/logs";
      dataDir = "/var/lib/jellyfin/data";
      configDir = "/var/lib/jellyfin/config";
      cacheDir = "/var/lib/jellyfin/cache";
    };
    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
    networking.firewall.allowedTCPPorts = [port];
  };
}
