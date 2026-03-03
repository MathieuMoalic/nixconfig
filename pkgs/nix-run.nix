{...}: let
  overlay = final: _: {
    "nix-run" = final.writeShellApplication {
      name = "nr";
      text = ''
        NIXPKGS_ALLOW_UNFREE=1 nix run nixpkgs#"$1" --impure
      '';
    };
  };
in {
  flake.overlays.nix-run = overlay;
}
