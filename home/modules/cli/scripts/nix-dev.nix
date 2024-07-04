{pkgs, ...}: let
  script1 = pkgs.writeShellApplication {
    name = "nr";
    text = ''
      NIXPKGS_ALLOW_UNFREE=1 nix run nixpkgs#"$1" --impure
    '';
  };
  script2 = pkgs.writeShellApplication {
    name = "ns";
    text = ''
      NIXPKGS_ALLOW_UNFREE=1 nix shell nixpkgs#"$1" --impure
    '';
  };
in {
  home.packages = [
    script1
    script2
  ];
}
