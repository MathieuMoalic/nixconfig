{
  lib,
  config,
  ...
}: {
  options.my.nixos.pkgs = lib.mkOption {
    type = lib.types.raw;
    readOnly = true;
    description = "Pinned pkgs set used to evaluate nixosConfigurations.";
  };

  config.my.nixos.pkgs = config.my.mkPkgs config.my.nixos.system;
}
