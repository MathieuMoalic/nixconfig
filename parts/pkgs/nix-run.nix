{
  lib,
  config,
  ...
}: let
  overlay = final: prev: {
    "nix-run" = final.writeShellApplication {
      name = "nr";
      text = ''
        NIXPKGS_ALLOW_UNFREE=1 nix run nixpkgs#"$1" --impure
      '';
    };
  };
in {
  my.overlays = lib.mkAfter [overlay];
  perSystem = {system, ...}: let pkgs = config.my.mkPkgs system; in {packages."nix-run" = pkgs."nix-run";};
}
