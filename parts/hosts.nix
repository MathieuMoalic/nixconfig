{lib, ...}: {
  options.my.hosts = lib.mkOption {
    type = lib.types.attrsOf lib.types.raw;
    default = {};
    description = "Host NixOS modules (module functions) used to build nixosConfigurations.";
  };
}
