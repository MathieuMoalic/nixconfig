{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";

    helix.url = "github:helix-editor/helix";

    hyprsome.url = "github:sopa0/hyprsome";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    ags.url = "github:Aylur/ags";

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
        specialArgs = {inherit inputs;};
        modules = [
          host
          inputs.home-manager.nixosModules.home-manager
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
