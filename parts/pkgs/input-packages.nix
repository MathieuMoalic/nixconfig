{
  lib,
  inputs,
  ...
}: let
  overlay = final: prev: {
    amumax = inputs.amumax.packages.${final.stdenv.hostPlatform.system}.git;
  };
in {
  my.overlays = lib.mkAfter [overlay];
}
