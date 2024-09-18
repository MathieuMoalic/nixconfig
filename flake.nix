{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nix-colors.url = "github:misterio77/nix-colors";
    helix.url = "github:helix-editor/helix";
    hyprsome.url = "github:sopa0/hyprsome";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    yazi.url = "github:sxyazi/yazi";
    ags.url = "github:Aylur/ags";
    quicktranslate.url = "github:MathieuMoalic/quicktranslate";
    mx3expend.url = "github:MathieuMoalic/mx3expend";
    amumax.url = "github:MathieuMoalic/amumax";
    sops-nix.url = "github:Mic92/sops-nix";
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    makeNixosSystem = host:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
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
    };
  };
}
