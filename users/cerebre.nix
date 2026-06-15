{
  flake.nixosModules.cerebre = {
    lib,
    pkgs,
    ...
  }: {
    users = {
      groups.cerebre = {};

      users.cerebre = {
        isSystemUser = true;
        group = "cerebre";
        description = "Restic backup user for friend";
        home = "/repo";
        shell = "${pkgs.shadow}/bin/nologin";

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMXoZPjHGfkAAaSqg8/p9R1920caIw0vkHywAtck3kYl"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPcmHHg1pEOAxvEAyr6p5MY0m3/+BOn8nJOcAf7mMaej"
        ];
      };
    };

    fileSystems."/mnt/ehdd/cerebre" = {
      device = "/mnt/ehdd/cerebre.img";
      fsType = "ext4";
      options = [
        "loop"
        "nofail"
        "x-systemd.requires-mounts-for=/mnt/ehdd"
      ];
    };

    systemd.tmpfiles.rules = [
      # Mountpoint / chroot root.
      "d /mnt/ehdd/cerebre 0755 root root -"

      # Writable restic repo inside the mounted image.
      "d /mnt/ehdd/cerebre/repo 0750 cerebre cerebre -"
    ];

    services.openssh.settings.AllowUsers = ["cerebre"];
    services.openssh.extraConfig = lib.mkAfter ''
      Match User cerebre
        ChrootDirectory /mnt/ehdd/cerebre
        ForceCommand internal-sftp -d /repo
        AllowTcpForwarding no
        AllowStreamLocalForwarding no
        X11Forwarding no
        AllowAgentForwarding no
        PermitTunnel no
        PermitTTY no
        PasswordAuthentication no
        KbdInteractiveAuthentication no
    '';
  };
}
