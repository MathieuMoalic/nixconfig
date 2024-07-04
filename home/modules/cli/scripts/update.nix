{pkgs, ...}: let
  script = pkgs.writeShellApplication {
    name = "up";
    text = ''
      set -e
      cd "$HOME"/nix
      git pull
      ${pkgs.alejandra}/bin/alejandra -q .
      ${pkgs.git}/bin/git add .
      sudo nixos-rebuild switch --flake .#"$HOST" --show-trace 2>&1 | grep -v "warning: Git tree '/home/mat/nix' is dirty"
      cd -
      rm -f ~/.zshenv
      exec ${pkgs.zsh}/bin/zsh -l
    '';
  };
in {
  home.packages = [
    script
  ];
}
