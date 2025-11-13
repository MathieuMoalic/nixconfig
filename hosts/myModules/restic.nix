{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.myModules.restic;
in {
  options.myModules.restic.enable = lib.mkEnableOption "restic";

  config = lib.mkIf cfg.enable {
    sops.secrets."restic/password" = {
      owner = "mat";
      group = "mat";
      mode = "0400";
    };

    environment.systemPackages = with pkgs; [restic];

    services.restic.backups = let
      commonSettings = {
        initialize = true;
        user = "root";
        paths = ["/var/lib"];
        passwordFile = config.sops.secrets."restic/password".path;
        runCheck = true;
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      };
    in {
      eHDD = commonSettings // {repository = "/mnt/ehdd/backup";};
      nas = commonSettings // {repository = "/mnt/nas/backup";};
      nas2 = commonSettings // {repository = "/mnt/nas2/backup";};
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
  };
}
