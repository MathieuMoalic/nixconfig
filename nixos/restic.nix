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

    requireNfsMount = mountPoint: mountUnit: {
      requires = [mountUnit];
      after = [mountUnit];

      # Do not trust ConditionPathIsMountPoint here: systemd's autofs
      # mount itself counts as a mount point. Verify that the real
      # filesystem mounted at this path is actually NFS.
      serviceConfig.ExecCondition = "${pkgs.util-linux}/bin/findmnt -rn -M ${mountPoint} -t nfs,nfs4";
    };
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
      requires = ["mnt-ehdd.mount"];
      after = ["mnt-ehdd.mount"];
    };

    systemd.services."restic-backups-nas" =
      requireNfsMount "/mnt/nas" "mnt-nas.mount";

    systemd.services."restic-backups-nas2" =
      requireNfsMount "/mnt/nas2" "mnt-nas2.mount";

    systemd.services.restic-weekly-check = {
      description = "Weekly Restic repository integrity checks";

      wants = ["network-online.target"];

      # Require the real mount units. If either NAS is unavailable,
      # this service must not proceed and accidentally use the
      # underlying directories on the root filesystem.
      requires = [
        "mnt-ehdd.mount"
        "mnt-nas.mount"
        "mnt-nas2.mount"
      ];

      after = [
        "network-online.target"
        "mnt-ehdd.mount"
        "mnt-nas.mount"
        "mnt-nas2.mount"
      ];

      environment.RESTIC_CACHE_DIR = "/var/cache/restic-weekly-check";

      serviceConfig = {
        Type = "oneshot";
        User = "root";

        CacheDirectory = "restic-weekly-check";
        CacheDirectoryMode = "0700";

        PrivateTmp = true;
        TimeoutStartSec = "6h";

        # Double-check the actual filesystem types immediately before
        # running Restic. In particular, an autofs mount at /mnt/nas*
        # must not pass these checks.
        ExecCondition = [
          "${pkgs.util-linux}/bin/findmnt -rn -M /mnt/ehdd"
          "${pkgs.util-linux}/bin/findmnt -rn -M /mnt/nas -t nfs,nfs4"
          "${pkgs.util-linux}/bin/findmnt -rn -M /mnt/nas2 -t nfs,nfs4"
        ];
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
