{pkgs, ...}: let
  up = pkgs.writeShellScriptBin "up" ''
    set -e

    cd $HOME/nix

    ${pkgs.alejandra}/bin/alejandra -q .

    ${pkgs.git}/bin/git add .

    sudo nixos-rebuild switch --flake .#$HOST --show-trace

    cd -

    rm -f ~/.zshenv

    # Notify all OK!
    ${pkgs.libnotify}/bin/notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
    exec ${pkgs.zsh}/bin/zsh -l
  '';
in {
  home.packages = [
    up
  ];
}
