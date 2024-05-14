{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";
    helix.url = "github:helix-editor/helix";
    hyprsome.url = "github:sopa0/hyprsome";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quicktranslate.url = "github:MathieuMoalic/quicktranslate";
    mx3expend.url = "github:MathieuMoalic/mx3expend";
    amumax.url = "github:MathieuMoalic/amumax";
  };

  outputs = {...} @ inputs: let
    makeNixosSystem = {
      host,
      home,
      ...
    }:
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
                  home
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
      xps = makeNixosSystem {
        host = ./hosts/xps.nix;
        home = ./home/xps.nix;
      };
      nyx = makeNixosSystem {
        host = ./hosts/nyx.nix;
        home = ./home/nyx.nix;
      };
      homeserver = makeNixosSystem {
        host = ./hosts/homeserver.nix;
        home = ./home/homeserver.nix;
      };
      zeus = makeNixosSystem {
        host = ./hosts/zeus.nix;
        home = ./home/zeus.nix;
      };
      iso = makeNixosSystem {
        host = ./hosts/iso.nix;
        home = ./home/iso.nix;
      };
    };
  };
}
