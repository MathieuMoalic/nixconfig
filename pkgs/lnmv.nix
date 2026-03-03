{...}: let
  overlay = final: prev: {
    lnmv = final.writeShellApplication {
      name = "lnmv";
      text = ''mv "$1" "$1.bak" && cat "$1.bak" > "$1"'';
    };
  };
in {
  flake.overlays.lnmv = overlay;
}
