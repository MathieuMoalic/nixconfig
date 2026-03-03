{
  flake.nixosModules.flaresolverr = {
    lib,
    config,
    ...
  }: {
    services = {
      flaresolverr.port = 8191;
      flaresolverr.enable = true;
    };
  };
}
