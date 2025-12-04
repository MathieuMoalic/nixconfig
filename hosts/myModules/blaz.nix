{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.myModules.blaz;
  types = lib.types;
in {
  options.myModules.blaz = {
    enable = lib.mkEnableOption "Blaz backend";

    package = lib.mkOption {
      type = types.package;
      default = pkgs.blaz;
    };

    user = lib.mkOption {
      type = types.str;
      default = "blaz";
    };

    group = lib.mkOption {
      type = types.str;
      default = "blaz";
    };
    port = lib.mkOption {
      type = types.port;
      default = 8080;
    };
    url = lib.mkOption {
      type = types.str;
      default = "blaz.matmoa.eu";
    };

    dataDir = lib.mkOption {
      type = types.path;
      default = "/var/lib/blaz";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.${cfg.group} = {};
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.blaz = {
      description = "blaz backend";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/blaz";
        WorkingDirectory = "/var/lib/blaz";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "blaz";

        # Security hardening
        CapabilityBoundingSet = "";
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
        SystemCallFilter = "~@clock @cpu-emulation @keyring @module @obsolete @raw-io @reboot @swap @resources @privileged @mount @debug";
        NoNewPrivileges = "yes";
        ProtectClock = "yes";
        ProtectKernelLogs = "yes";
        ProtectControlGroups = "yes";
        ProtectKernelModules = "yes";
        SystemCallArchitectures = "native";
        RestrictNamespaces = "yes";
        RestrictSUIDSGID = "yes";
        ProtectHostname = "yes";
        ProtectKernelTunables = "yes";
        RestrictRealtime = "yes";
        ProtectProc = "invisible";
        PrivateUsers = "yes";
        LockPersonality = "yes";
        UMask = "0077";
        RemoveIPC = "yes";
        LimitCORE = "0";
        ProtectHome = "yes";
        PrivateTmp = "yes";
        ProtectSystem = "strict";
        ProcSubset = "pid";
        SocketBindAllow = ["tcp:${builtins.toString cfg.port}"];
        SocketBindDeny = "any";

        LimitNOFILE = 1024;
        LimitNPROC = 64;
        MemoryMax = "200M";
      };
    };

    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
