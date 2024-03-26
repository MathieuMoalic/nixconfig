{pkgs, ...}: let
  up = pkgs.writeShellScriptBin "up" ''
    cd $HOME/nix && git add . && sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake /home/mat/nix#$HOST --option eval-cache false --impure && cd -; rm -f ~/.zshenv; exec zsh -l
  '';
in {
  home.packages = [
    up
  ];
}
