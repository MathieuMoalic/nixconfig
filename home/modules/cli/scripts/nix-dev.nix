{pkgs, ...}: let
  nix-dev-shell = pkgs.writeShellScriptBin "nd" ''
    hash=$(echo -n "$(pwd)" | sha256sum | awk '{print $1}')
    nix develop $XDG_CACHE_HOME/nix-dev-shells/$hash -c zsh
  '';
  nix-dev-mk = pkgs.writeShellScriptBin "ndmk" ''
    hash=$(echo -n "$(pwd)" | sha256sum | awk '{print $1}')
    mkdir -p $XDG_CACHE_HOME/nix-dev-shells
    nix develop --profile $XDG_CACHE_HOME/nix-dev-shells/$hash
  '';
  nix-run = pkgs.writeShellScriptBin "nr" ''
    NIXPKGS_ALLOW_UNFREE=1 nix run nixpkgs#$1 --impure
  '';
  nix-shell = pkgs.writeShellScriptBin "ns" ''
    NIXPKGS_ALLOW_UNFREE=1 nix shell nixpkgs#$1 --impure
  '';
in {
  home.packages = [
    nix-dev-shell
    nix-dev-mk
    nix-run
    nix-shell
  ];
}
