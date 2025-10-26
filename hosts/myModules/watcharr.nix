{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.myModules.watcharr;
  types = lib.types;
  port = 3080; # this is hardcoded in watcharr ...
in {
  options.myModules.watcharr = {
    enable = lib.mkEnableOption "Watcharr media tracker";

    package = lib.mkOption {
      type = types.package;
      default = pkgs.callPackage ../../pkgs/watcharr {};
    };

    user = lib.mkOption {
      type = types.str;
      default = "watcharr";
    };

    group = lib.mkOption {
      type = types.str;
      default = "media";
    };

    url = lib.mkOption {
      type = types.str;
      default = "watcharr.matmoa.eu";
    };

    dataDir = lib.mkOption {
      type = types.path;
      default = "/var/lib/watcharr";
    };
  };

  config = lib.mkIf cfg.enable {
    # Ensure service user/group exist
    users.groups.${cfg.group} = {};
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
    };

    # Ensure data dir exists with the right perms
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.watcharr = {
      description = "Watcharr server";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      environment = {
        WATCHARR_DATA = toString cfg.dataDir;
      };
      path = [pkgs.nodejs_20];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;

        # Run inside the store path so relative "./ui" resolves
        WorkingDirectory = cfg.package;

        # Prefer $out/bin/watcharr; fall back to $out/bin/server if needed
        ExecStart = "${cfg.package}/bin/Watcharr";

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
        ReadWritePaths = [cfg.dataDir];
      };
    };
    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
