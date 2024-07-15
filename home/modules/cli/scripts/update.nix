{
  pkgs,
  osConfig,
  ...
}: let
  script = pkgs.writeShellApplication {
    name = "up";
    text = ''
      set -e
      cd "$HOME"/nix
      git pull
      ${pkgs.alejandra}/bin/alejandra -q .
      ${pkgs.git}/bin/git add .
      NIXOS_LABEL="$(date)" ${pkgs.nh}/bin/nh os switch "$HOME/nix"
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
