{
  flake.nixosModules.restic = {
    pkgs,
    lib,
    config,
    self,
    ...
  }: let
    ntfyTopic = "restic-checks";
    ntfyEndpoint = "https://ntfy.matmoa.eu/${ntfyTopic}";

    checkRepository = name: let
      backup = config.services.restic.backups.${name};
    in ''
      echo "Checking Restic repository: ${name}"

      ${lib.getExe backup.package} \
        --repo ${lib.escapeShellArg backup.repository} \
        --password-file ${lib.escapeShellArg backup.passwordFile} \
        --retry-lock 2h \
        check --read-data-subset=1%
    '';
  in {
    imports = with self.nixosModules; [
      nfs
    ];

    sops.secrets."restic/password" = {
      owner = "mat";
      group = "mat";
      mode = "0400";
    };

    environment.systemPackages = with pkgs; [
      restic
    ];

    services.restic.backups = let
      commonSettings = {
        initialize = true;
        user = "root";
        paths = ["/var/lib"];
        exclude = ["/var/lib/containers"];
        passwordFile = config.sops.secrets."restic/password".path;

        runCheck = true;

        timerConfig = {
          OnCalendar = "04:00";
          Persistent = true;
        };
      };
    in {
      eHDD =
        commonSettings
        // {
          repository = "/mnt/ehdd/backup";
        };

      nas =
        commonSettings
        // {
          repository = "/mnt/nas/backup";
        };

      nas2 =
        commonSettings
        // {
          repository = "/mnt/nas2/backup";
        };
    };

    systemd.services."restic-backups-eHDD" = {
      unitConfig.ConditionPathIsMountPoint = "/mnt/ehdd";
      after = ["mnt-ehdd.mount"];
    };

    systemd.services."restic-backups-nas" = {
      unitConfig.ConditionPathIsMountPoint = "/mnt/nas";
      after = ["mnt-nas.mount"];
    };

    systemd.services."restic-backups-nas2" = {
      unitConfig.ConditionPathIsMountPoint = "/mnt/nas2";
      after = ["mnt-nas2.mount"];
    };

    systemd.services.restic-weekly-check = {
      description = "Weekly Restic repository integrity checks";

      wants = ["network-online.target"];
      after = ["network-online.target"];

      unitConfig = {
        RequiresMountsFor = [
          "/mnt/ehdd"
          "/mnt/nas"
          "/mnt/nas2"
        ];

        ConditionPathIsMountPoint = [
          "/mnt/ehdd"
          "/mnt/nas"
          "/mnt/nas2"
        ];
      };

      environment.RESTIC_CACHE_DIR = "/var/cache/restic-weekly-check";

      serviceConfig = {
        Type = "oneshot";
        User = "root";

        CacheDirectory = "restic-weekly-check";
        CacheDirectoryMode = "0700";

        PrivateTmp = true;
        TimeoutStartSec = "6h";
      };

      script = ''
        set -euo pipefail

        ${checkRepository "eHDD"}
        ${checkRepository "nas"}
        ${checkRepository "nas2"}

        ${lib.getExe pkgs.curl} \
          --fail-with-body \
          --silent \
          --show-error \
          --retry 3 \
          --retry-all-errors \
          --connect-timeout 10 \
          --max-time 30 \
          -H ${lib.escapeShellArg "Title: Restic checks succeeded"} \
          -H ${lib.escapeShellArg "Tags: white_check_mark,floppy_disk"} \
          --data-binary ${lib.escapeShellArg "All Restic repositories passed the weekly 10% data check on ${config.networking.hostName}: eHDD, nas and nas2."} \
          ${lib.escapeShellArg ntfyEndpoint}
      '';
    };

    systemd.timers.restic-weekly-check = {
      description = "Run Restic repository checks every Monday at 05:00";
      wantedBy = ["timers.target"];

      timerConfig = {
        OnCalendar = "Mon *-*-* 05:00:00";
        Persistent = true;
        Unit = "restic-weekly-check.service";
      };
    };
  };
}
