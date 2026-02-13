{
  inputs = {
    amumax.url = "github:MathieuMoalic/amumax";

    boued = {
      url = "github:MathieuMoalic/boued";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homepage = {
      url = "github:MathieuMoalic/homepage";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs_unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zjstatus.url = "github:dj95/zjstatus";
    amumax.url = "github:MathieuMoalic/amumax";
    quicktranslate.url = "github:MathieuMoalic/quicktranslate";
    homepage.url = "github:MathieuMoalic/homepage";
    pleustradenn.url = "github:MathieuMoalic/pleustradenn";
    blaz.url = "github:MathieuMoalic/blaz";
    boued.url = "github:MathieuMoalic/boued";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        (inputs.import-tree ./parts)
      ];
    };
}
