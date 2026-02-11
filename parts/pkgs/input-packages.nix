{
  lib,
  inputs,
  ...
}: let
  overlay = final: prev: {
    amumax = inputs.amumax.packages.${final.stdenv.hostPlatform.system}.git;

    "nvim-unstable" =
      inputs.nixpkgs_unstable.legacyPackages.${final.stdenv.hostPlatform.system}.neovim-unwrapped;

    zjstatus = inputs.zjstatus.packages.${final.stdenv.hostPlatform.system}.default;
  };
in {
  my.overlays = lib.mkAfter [overlay];
}
