{pkgs, ...}:
pkgs.writeShellApplication {
  name = "nr";
  text = ''
    NIXPKGS_ALLOW_UNFREE=1 nix run nixpkgs#"$1" --impure
  '';
}
