{pkgs, ...}: let
  nix-run = pkgs.writeShellScriptBin "nr" ''
    nix run nixpkgs#$1
  '';
  nix-shell = pkgs.writeShellScriptBin "ns" ''
    nix shell nixpkgs#$1
  '';
in {
  home.packages = [
    nix-run
    nix-shell
  ];
}
