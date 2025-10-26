{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.myModules.libretranslate;
  types = lib.types;
in {
  options.myModules.libretranslate = {
    enable = lib.mkEnableOption "libretranslate behind Caddy";

    url = lib.mkOption {
      type = types.str;
      default = "libretranslate.matmoa.eu";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10027;
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = {
      libretranslate = {
        group = "libretranslate";
        isSystemUser = true;
      };
    };
    users.groups = {libretranslate = {};};

    systemd.services.libretranslate = {
      description = "LibreTranslate";
      wantedBy = ["multi-user.target"];
      after = ["network-online.target"];
      wants = ["network-online.target"];

      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.libretranslate}/bin/libretranslate \
            --host localhost \
            --port ${toString cfg.port} \
            --threads 4 \
            --load-only en,pl,fr
        '';

        StateDirectory = "libretranslate";
        WorkingDirectory = "/var/lib/libretranslate";
        Environment = "HOME=/var/lib/libretranslate";

        Restart = "on-failure";

        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        LockPersonality = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;
        SystemCallFilter = ["~@cpu-emulation @debug @keyring @mount @obsolete @privileged @setuid"];
        MemoryDenyWriteExecute = false;
        User = "libretranslate";
        Group = "libretranslate";
        ProcSubset = "all";
        ProtectProc = "invisible";
        UMask = "0027";
        CapabilityBoundingSet = "";
        PrivateDevices = true;
        PrivateUsers = true;
        RestrictAddressFamilies = ["AF_INET" "AF_INET6"];
        RestrictNamespaces = true;
        RemoveIPC = true;
        PrivateMounts = true;
        SystemCallArchitectures = "native";
      };
    };
    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
