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
  services.restic.backups = {
    podmanBackupLocal = {
      initialize = true;
      user = "mat";
      repository = "/home/mat/backup";
      paths = ["/home/mat/podman"];
      passwordFile = config.sops.secrets.restic.path;
      runCheck = true;
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };

    podmanBackupRemote = {
      initialize = true;
      user = "mat";
      repository = "rclone:nyx:z1/backup";
      paths = ["/home/mat/podman"];
      rcloneConfigFile = /home/mat/.config/rclone/rclone.conf;
      passwordFile = config.sops.secrets.restic.path;
      runCheck = true;
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };
  };
}
