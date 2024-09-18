{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    restic
  ];
  users.users.restic = {
    isNormalUser = true;
  };

  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = "restic";
    group = "users";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };

  services.restic.backups = {
    podmanBackupLocal = {
      initialize = true;
      user = "mat";
      repository = "/home/mat/backup";
      paths = ["/home/mat/podman"];
      passwordFile = config.age.secrets.restic.path;
      exclude = ["*.tmp"];
      runCheck = true;
      extraOptions = ["--verbose"];
      timerConfig = {
        OnCalendar = "daily"; # Run daily backups
        Persistent = true;
      };
    };

    podmanBackupRemote = {
      initialize = true;
      user = "mat";
      repository = "rclone:nyx:z1/backup";
      paths = ["/home/mat/podman"];
      exclude = ["*.tmp"];
      rcloneConfigFile = /home/mat/.config/rclone/rclone.conf;
      passwordFile = config.age.secrets.restic.path;
      runCheck = true;
      timerConfig = {
        OnCalendar = "daily"; # Run daily backups
        Persistent = true;
      };
    };
  };
}
