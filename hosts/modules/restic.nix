{
  pkgs,
  config,
  ...
}: {
  sops.secrets = {
    restic = {
      owner = config.users.users.mat.name;
    };
  };

  environment.systemPackages = with pkgs; [
    restic
  ];

  services.restic.backups = let
    commonSettings = {
      initialize = true;
      user = "mat";
      paths = ["${config.users.users.mat.home}/podman"];
      passwordFile = config.sops.secrets.restic.path;
      runCheck = true;
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };
  in {
    podmanBackupLocal =
      commonSettings
      // {
        repository = "${config.users.users.mat.home}/backup";
      };

    podmanBackupRemote =
      commonSettings
      // {
        repository = "rclone:nyx:z1/backup";
        rcloneConfigFile = "${config.users.users.mat.home}/.config/rclone/rclone.conf";
      };
  };
}
