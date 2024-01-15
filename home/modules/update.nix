{pkgs, ...}: let
  up = pkgs.writeShellScriptBin "up" ''
    cd $HOME/nix && git add . && sudo nixos-rebuild switch --flake /home/mat/nix#$HOST && cd -
    rm ~/.zshenv
  '';
in {
  home.packages = [
    up
  ];
}
