{
  inputs = {
    blaz = {
      url = "github:MathieuMoalic/blaz";
    };

    mont = {
      url = "github:MathieuMoalic/mont";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    boued = {
      url = "github:MathieuMoalic/boued";
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

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        inputs.home-manager.flakeModules.home-manager
        (inputs.import-tree ./home)
        (inputs.import-tree ./hosts)
        (inputs.import-tree ./nixos)
        (inputs.import-tree ./pkgs)
        (inputs.import-tree ./users)
        ./mkHost.nix
      ];
    };
}
