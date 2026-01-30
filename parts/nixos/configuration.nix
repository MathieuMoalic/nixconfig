{config, ...}: {
  flake.nixosConfigurations =
    builtins.mapAttrs (_: hostModule: config.my.nixos.mkHost hostModule)
    config.my.hosts;
}
