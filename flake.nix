{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    helix.url = "github:helix-editor/helix";
    hyprsome.url = "github:sopa0/hyprsome";
    amumax.url = "github:SomeoneSerge/pkgs";
    hyprland.url = "github:hyprwm/Hyprland"; # git release version
    # sops-nix.url = "github:Mic92/sops-nix";
    # sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    home-manager,
    nixpkgs,
    hyprsome,
    nix-colors,
    amumax,
    ...
  } @ inputs: let
    makeNixosSystem = {host, ...}:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit nix-colors inputs;
        };
        modules = [
          ./hosts/base.nix
          host
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit nix-colors amumax inputs;
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
          }
        ];
      };
  in {
    nixosConfigurations = {
      xps = makeNixosSystem {host = ./hosts/xps;};
      nyx = makeNixosSystem {host = ./hosts/nyx;};
    };
  };
}
