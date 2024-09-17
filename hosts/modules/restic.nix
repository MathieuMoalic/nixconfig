{pkgs, ...}: {
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
      user = "mat";
      repository = "/home/mat/backup";
      paths = ["/home/mat/podman"];
      passwordFile = "/home/mat/.restic-password";
      exclude = ["*.tmp"];
      runCheck = true;
      extraOptions = ["--verbose"];
      timerConfig = {
        OnCalendar = "daily"; # Run daily backups
        Persistent = true;
      };
    };

    podmanBackupRemote = {
      user = "mat";
      repository = "nyx:/z1/backup";
      paths = ["/home/mat/podman"];
      passwordFile = "/home/mat/.restic-password";
      exclude = ["*.tmp"];
      runCheck = true;
      extraOptions = ["--verbose"];
      timerConfig = {
        OnCalendar = "daily"; # Run daily backups
        Persistent = true;
      };
      # Optional: You can also provide specific SSH options with rcloneOptions
      extraOptions = ["--verbose"];
    };
  };
}
