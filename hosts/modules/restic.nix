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
      paths = ["/home/mat/podman"];
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
        repository = "/home/mat/backup";
      };

    podmanBackupRemote =
      commonSettings
      // {
        repository = "rclone:nyx:z1/backup";
        rcloneConfigFile = /home/mat/.config/rclone/rclone.conf;
      };
  };
}
