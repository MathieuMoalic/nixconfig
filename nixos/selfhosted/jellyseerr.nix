{...}: {
  flake.nixosModules.jellyseerr = {
    lib,
    config,
    pkgs,
    ...
  }: let
    user = "jellyseerr";
    group = "media";
    url = "jellyseerr.matmoa.eu";
    port = 10023;
    configDir = "/var/lib/jellyseerr";
  in {
    users.users.${user} = {
      isSystemUser = true;
      group = group;
    };

    systemd.services.jellyseerr = {
      description = "Jellyseerr, a requests manager for Jellyfin";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      environment = {
        PORT = toString port;
        CONFIG_DIRECTORY = configDir;
      };
      serviceConfig = {
        Type = "exec";
        StateDirectory = "jellyseerr";
        User = user;
        Group = group;
        ExecStart = "${pkgs.jellyseerr}/bin/jellyseerr";
        Restart = "on-failure";
        ProtectHome = true;
        ProtectSystem = "strict";
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        NoNewPrivileges = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
      };
    };
    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
