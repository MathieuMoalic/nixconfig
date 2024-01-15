{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    helix.url = "github:helix-editor/helix";
    # xremap-flake.url = "github:xremap/nix-flake";
    hyprsome.url = "github:sopa0/hyprsome";
    amumax.url = "github:SomeoneSerge/pkgs";
    # sops-nix.url = "github:Mic92/sops-nix";
    # sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    home-manager,
    nixpkgs,
    hyprsome,
    nix-colors,
    ...
  }: let
    home = {
      extraSpecialArgs = {
        inherit nix-colors;
        wallpaperPath = "/home/mat/.local/share/wallpaper.jpeg";
      };
      useUserPackages = true;
      useGlobalPkgs = true;
      users.mat = {
        imports = [
          ./home
          nix-colors.homeManagerModules.default
        ];
        home.packages = [
          hyprsome.packages.x86_64-linux.default
        ];
      };
    };
  in {
    nixosConfigurations.xps = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit nix-colors;};
      modules = [
        ./hosts/base.nix
        ./hosts/xps
        home-manager.nixosModules.home-manager
        {
          home-manager = home;
        }
      ];
    };
    nixosConfigurations.nyx = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit nix-colors;};
      modules = [
        ./hosts/base.nix
        ./hosts/nyx
        home-manager.nixosModules.home-manager
        {
          home-manager = home;
        }
      ];
    };
  };
}
