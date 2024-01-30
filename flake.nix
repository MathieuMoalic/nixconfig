{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    helix.url = "github:helix-editor/helix";
    hyprsome.url = "github:sopa0/hyprsome";
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hycov = {
      url = "github:DreamMaoMao/hycov";
      inputs.hyprland.follows = "hyprland";
    };
    hyprfocus = {
      url = "github:VortexCoyote/hyprfocus";
      inputs.hyprland.follows = "hyprland";
    };
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    quicktranslate.url = "github:MathieuMoalic/quicktranslate";
    mx3expend.url = "github:MathieuMoalic/mx3expend";
    amumax.url = "github:MathieuMoalic/amumax";
    # sops-nix.url = "github:Mic92/sops-nix";
    # sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    home-manager,
    nixpkgs,
    nix-colors,
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
                inherit nix-colors inputs;
                wallpaperPath = "/home/mat/.local/share/wallpaper.jpeg";
              };
              useUserPackages = true;
              useGlobalPkgs = true;
              users.mat = {
                imports = [
                  ./home
                  nix-colors.homeManagerModules.default
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
      homeserver = makeNixosSystem {host = ./hosts/homeserver;};
    };
  };
}
