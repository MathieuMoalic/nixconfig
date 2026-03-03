{self, ...}: {
  flake.nixosModules.mat-desktop = {...}: {
    home-manager.users.mat = {
      imports = with self.homeModules; [
        desktop
      ];
    };
  };
}
