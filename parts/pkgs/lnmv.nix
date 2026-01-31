{
  lib,
  config,
  ...
}: let
  overlay = final: prev: {
    lnmv = final.writeShellApplication {
      name = "lnmv";
      text = ''mv "$1" "$1.bak" && cat "$1.bak" > "$1"'';
    };
  };
in {
  my.overlays = lib.mkAfter [overlay];
  perSystem = {system, ...}: let pkgs = config.my.mkPkgs system; in {packages.lnmv = pkgs.lnmv;};
}
