{lib, ...}: {
  options.my.nixos.system = lib.mkOption {
    type = lib.types.str;
    default = "x86_64-linux";
    description = "System used for nixosConfigurations";
  };
}
