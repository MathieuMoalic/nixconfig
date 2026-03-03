{...}: {
  flake.nixosModules.cerebre = {pkgs, ...}: {
    users = {
      groups.cerebre = {};
      users.cerebre = {
        isSystemUser = true;
        group = "cerebre";
        description = "Restic backup user for friend";
        home = "/mnt/ehdd/cerebre";
        shell = "${pkgs.shadow}/bin/nologin";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMXoZPjHGfkAAaSqg8/p9R1920caIw0vkHywAtck3kYl"
        ];
      };
    };
  };
}
