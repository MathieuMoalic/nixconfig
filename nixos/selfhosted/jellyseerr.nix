{
  flake.nixosModules.jellyseerr = {
    lib,
    pkgs,
    ...
  }: let
    user = "jellyseerr";
    group = "media";
    url = "jellyseerr.matmoa.eu";
    port = 10023;
  in {
    users.users.${user} = {
      isSystemUser = true;
      group = group;
    };

    services.seerr = {
      enable = true;
      port = port;
      configDir = "/var/lib/jellyseerr";
      openFirewall = false;
    };

    systemd.services.seerr.serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = lib.mkForce user;
      Group = lib.mkForce group;
      StateDirectory = lib.mkForce "jellyseerr";
    };

    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
