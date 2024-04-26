{pkgs, ...}: let
  up = pkgs.writeShellScriptBin "up" ''
    set -e

    cd $HOME/nix

    ${pkgs.alejandra}/bin/alejandra -q .

    ${pkgs.git}/bin/git add .

    sudo nixos-rebuild switch --flake .#$HOST --show-trace 2>&1 | grep -v "warning: Git tree '/home/mat/nix' is dirty"

    cd -

    rm -f ~/.zshenv

    # Notify all OK!
    exec ${pkgs.zsh}/bin/zsh -l
  '';
in {
  home.packages = [
    up
  ];
}
