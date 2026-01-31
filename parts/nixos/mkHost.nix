{
  lib,
  inputs,
  config,
  ...
}: {
  options.my.nixos.mkHost = lib.mkOption {
    type = lib.types.raw;
    readOnly = true;
    description = "hostModule -> nixosSystem builder.";
  };

  config.my.nixos.mkHost = hostModule:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      pkgs = config.my.mkPkgs "x86_64-linux";

      specialArgs = {inherit inputs;};

      modules = [
        ../../hosts/base.nix
        hostModule
      ];
    };
}
