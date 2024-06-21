{pkgs, ...}: let
  lnmv = pkgs.writeShellScriptBin "lnmv" ''
    mv "$1" "$1.bak" && cat "$1.bak" > "$1"
  '';
in {
  home.packages = [
    lnmv
  ];
}
