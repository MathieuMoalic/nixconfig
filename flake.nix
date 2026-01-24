{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs_unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    sops-nix.url = "github:Mic92/sops-nix";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zjstatus.url = "github:dj95/zjstatus";
    amumax.url = "github:MathieuMoalic/amumax";
    quicktranslate.url = "github:MathieuMoalic/quicktranslate";
    homepage.url = "github:MathieuMoalic/homepage";
    pleustradenn.url = "github:MathieuMoalic/pleustradenn";
    boued.url = "github:MathieuMoalic/boued";
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    helpers = import ./hosts/myModules/helper.nix {inherit lib;};
    myModules = helpers.mkModulesFromDir {dir = ./hosts/myModules;};
    makeNixosSystem = host:
      nixpkgs.lib.nixosSystem {
        inherit system;
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            ((import ./overlays/overlays.nix) inputs)
          ];
          config = {
            allowUnfree = true;
          };
        };
        specialArgs = {inherit inputs;};
        modules =
          [
            host
            inputs.home-manager.nixosModules.home-manager
            inputs.homepage.nixosModules.homepage-service
            inputs.pleustradenn.nixosModules.pleustradenn-service
            inputs.boued.nixosModules.boued-service
            inputs.sops-nix.nixosModules.sops
            inputs.disko.nixosModules.disko
          ]
          ++ helpers.moduleListFromDir {dir = ./hosts/myModules;};
      };
  in {
    nixosModules = myModules;
    nixosConfigurations = {
      xps = makeNixosSystem ./hosts/xps.nix;
      nyx = makeNixosSystem ./hosts/nyx.nix;
      homeserver = makeNixosSystem ./hosts/homeserver.nix;
      zeus = makeNixosSystem ./hosts/zeus.nix;
      alecto = makeNixosSystem ./hosts/alecto.nix;
      zagreus = makeNixosSystem ./hosts/zagreus.nix;
      kiosk = makeNixosSystem ./hosts/kiosk.nix;
    };
  };
}
