{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    helix.url = "github:helix-editor/helix";
    xremap-flake.url = "github:xremap/nix-flake";
    hyprsome.url = "github:sopa0/hyprsome";
    amumax.url = "github:SomeoneSerge/pkgs";
    # sops-nix.url = "github:Mic92/sops-nix";
    # sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprsome,
    amumax,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      xps = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/configuration.nix];
      };
    };
    homeConfigurations = {
      "mat@xps" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          wallpaperPath = "/home/mat/.local/share/wallpaper.jpeg";
        };
        modules = [./home-manager/home.nix];
      };
    };
  };
}
