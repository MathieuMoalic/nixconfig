{...}: {
  flake.nixosModules.watcharr = {
    lib,
    config,
    pkgs,
    ...
  }: let
    port = 3080; # this is hardcoded in watcharr ...
    package = pkgs.watcharr;
    user = "watcharr";
    group = "media";
    url = "watcharr.matmoa.eu";
    dataDir = "/var/lib/watcharr";
  in {
    # Ensure service user/group exist
    users.groups.${group} = {};
    users.users.${user} = {
      isSystemUser = true;
      group = group;
    };

    # Ensure data dir exists with the right perms
    systemd.tmpfiles.rules = [
      "d ${dataDir} 0750 ${user} ${group} - -"
    ];

    systemd.services.watcharr = {
      description = "Watcharr server";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      environment = {
        WATCHARR_DATA = toString dataDir;
      };
      path = [pkgs.nodejs_20];

      serviceConfig = {
        Type = "simple";
        User = user;
        Group = group;

        # Run inside the store path so relative "./ui" resolves
        WorkingDirectory = package;

        # Prefer $out/bin/watcharr; fall back to $out/bin/server if needed
        ExecStart = "${package}/bin/Watcharr";

        Restart = "on-failure";
        RestartSec = "2s";

        # Hardening (unchanged)
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        # Allow writes only to the data dir
        ReadWritePaths = [dataDir];
      };
    };
    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
