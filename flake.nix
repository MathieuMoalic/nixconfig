{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs_unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    sops-nix.url = "github:Mic92/sops-nix";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nvf.url = "github:notashelf/nvf";

    amumax.url = "github:MathieuMoalic/amumax";
    quicktranslate.url = "github:MathieuMoalic/quicktranslate";
    homepage.url = "github:MathieuMoalic/homepage";
    pleustradenn.url = "github:MathieuMoalic/pleustradenn";
    boued.url = "github:MathieuMoalic/boued";
  };
  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
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
        modules = [host];
      };
  in {
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
