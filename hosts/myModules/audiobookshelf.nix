{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.myModules.audiobookshelf;
  types = lib.types;
in {
  options.myModules.audiobookshelf = {
    enable = lib.mkEnableOption "Audiobookshelf behind Caddy";

    package = lib.mkPackageOption pkgs "audiobookshelf" {};

    user = lib.mkOption {
      type = types.str;
      default = "audiobookshelf";
    };

    group = lib.mkOption {
      type = types.str;
      default = "media";
    };

    url = lib.mkOption {
      type = types.str;
      default = "audiobookshelf.matmoa.eu";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10021;
    };

    dataDir = lib.mkOption {
      default = "/var/lib/audiobookshelf";
      type = types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
    };

    systemd.services.audiobookshelf = {
      description = "Audiobookshelf is a self-hosted audiobook and podcast server";

      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "exec";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "audiobookshelf";
        WorkingDirectory = cfg.dataDir;
        ExecStart = "${cfg.package}/bin/audiobookshelf --host 127.0.0.1 --port ${toString cfg.port}";
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
    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
