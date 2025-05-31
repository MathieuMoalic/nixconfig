{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs_unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    quicktranslate.url = "github:MathieuMoalic/quicktranslate";
    amumax.url = "github:MathieuMoalic/amumax";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    sops-nix.url = "github:Mic92/sops-nix";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nvf.url = "github:notashelf/nvf";
    homepage.url = "github:MathieuMoalic/homepage";
    pleustradenn.url = "github:MathieuMoalic/pleustradenn";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
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
            inputs.hyprpanel.overlay
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
      iso = makeNixosSystem ./hosts/iso.nix;
      alecto = makeNixosSystem ./hosts/alecto.nix;
      zagreus = makeNixosSystem ./hosts/zagreus.nix;
      kiosk = makeNixosSystem ./hosts/kiosk.nix;
    };
  };
}
