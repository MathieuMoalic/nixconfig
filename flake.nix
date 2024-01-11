{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    helix.url = "github:helix-editor/helix";
    xremap-flake.url = "github:xremap/nix-flake";
    hyprsome.url = "github:sopa0/hyprsome";
    # sops-nix.url = "github:Mic92/sops-nix";
    # sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    home-manager,
    nixpkgs,
    hyprsome,
    nix-colors,
    ...
  }: {
    nixosConfigurations.xps = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit nix-colors;};
      modules = [
        ./nixos/base.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            extraSpecialArgs = {
              inherit nix-colors;
              wallpaperPath = "/home/mat/.local/share/wallpaper.jpeg";
            };
          };

          home-manager.useUserPackages = true;
          home-manager.useGlobalPkgs = true;
          home-manager.users.mat = {
            imports = [
              ./home/base.nix
              nix-colors.homeManagerModules.default
            ];
            home.packages = [
              hyprsome.packages.x86_64-linux.default
            ];
          };
        }
      ];
    };
    # nixosConfigurations = {
    #   xps = nixpkgs.lib.nixosSystem {
    #     specialArgs = {inherit inputs outputs;};
    #     modules = [./nixos/configuration.nix];
    #   };
    # };
    # homeConfigurations = {
    #   mat = home-manager.lib.homeManagerConfiguration {
    #     pkgs = nixpkgs.legacyPackages.x86_64-linux;
    #     extraSpecialArgs = {
    #       inherit inputs outputs;
    #       wallpaperPath = "/home/mat/.local/share/wallpaper.jpeg";
    #     };
    #     modules = [./home-manager/home.nix];
    #   };
    # };
  };
}
