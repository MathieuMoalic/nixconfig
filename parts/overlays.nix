{
  lib,
  config,
  ...
}: let
  # Compose overlay functions into one overlay function
  compose = overlays:
    lib.foldl' lib.composeExtensions (final: prev: {}) overlays;
in {
  options.my.overlays = lib.mkOption {
    type = lib.types.listOf lib.types.raw;
    default = [];
    description = "Overlay fragments contributed by parts modules.";
  };

  config.flake.overlays.default = compose config.my.overlays;
}
