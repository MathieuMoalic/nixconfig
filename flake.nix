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
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quicktranslate.url = "github:MathieuMoalic/quicktranslate";
    mx3expend.url = "github:MathieuMoalic/mx3expend/56faef06d42552cd7a981056cbf0347af673750d";
    amumax.url = "github:MathieuMoalic/amumax/bce4fa867f4ef2d3f20f60c63bbff21677367707";
  };

  outputs = {...} @ inputs: let
    makeNixosSystem = {host, ...}:
      inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/base.nix
          host
          inputs.home-manager.nixosModules.home-manager
          inputs.sops.nixosModules.sops
          {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs;
                wallpaperPath = "/home/mat/.local/share/wallpaper.jpeg";
              };
              useUserPackages = true;
              useGlobalPkgs = true;
              users.mat = {
                imports = [
                  ./home
                  inputs.nix-colors.homeManagerModules.default
                  inputs.nix-index-database.hmModules.nix-index # weekly nix-index refresh
                ];
              };
            };
          }
        ];
      };
  in {
    nixosConfigurations = {
      xps = makeNixosSystem {host = ./hosts/xps.nix;};
      nyx = makeNixosSystem {host = ./hosts/nyx.nix;};
      homeserver = makeNixosSystem {host = ./hosts/homeserver;};
    };
  };
}
