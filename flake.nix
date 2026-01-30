{
  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

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

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        (inputs.import-tree ./parts)
      ];
    };
}
