{...}: {
  flake.nixosModules.mat = {
    pkgs,
    inputs,
    self,
    ...
  }: {
    programs.fish.enable = true;

    users = {
      groups.mat.gid = 1000;
      users.mat = {
        isNormalUser = true;
        group = "mat";
        linger = true;
        uid = 1000;
        shell = pkgs.fish;
        extraGroups = ["networkmanager" "wheel" "video" "input" "uinput" "media" "audio" "seat" "kvm" "libvirtd"];
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPcmHHg1pEOAxvEAyr6p5MY0m3/+BOn8nJOcAf7mMaej"];
        hashedPassword = "$6$gMQHadaVYwaBrtfO$y8pVFG0p2mT.iDQ5XYdTIG8GaqNDaQFwuH29z4VaJkYwlYGKCkrZClAixfl8IcPL3aqIh80cv7sq6M2nBx9gd1";
      };
    };

    home-manager.users.mat = {
      home.stateVersion = "23.05";
      programs.man.enable = false;
      imports = with self.homeModules; [
        inputs.nix-colors.homeManagerModules.default
        inputs.nvf.homeManagerModules.default
        inputs.nix-index-database.homeModules.nix-index
        userDirs
        sessionVariables
        nixSettings
        colorScheme
        cli
      ];
    };
  };
}
