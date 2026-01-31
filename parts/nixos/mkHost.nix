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
      system = config.my.nixos.system;
      pkgs = config.my.nixos.pkgs;

      specialArgs = {inherit inputs;};

      modules = [
        ../../hosts/base.nix
        hostModule
      ];
    };
}
