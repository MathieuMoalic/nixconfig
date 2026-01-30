{
  inputs,
  config,
  ...
}: let
  system = "x86_64-linux";

  mkPkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [
      ((import ../overlays/overlays.nix) inputs)
    ];
    config.allowUnfree = true;
  };

  mkHost = hostModule:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      pkgs = mkPkgs;

      specialArgs = {inherit inputs;};

      modules = [
        ../hosts/base.nix
        hostModule
      ];
    };
in {
  flake.nixosConfigurations =
    builtins.mapAttrs (_: hostModule: mkHost hostModule) config.my.hosts;
}
