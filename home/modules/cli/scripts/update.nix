{pkgs, ...}: let
  script = pkgs.writeShellApplication {
    name = "up";
    runtimeInputs = with pkgs; [alejandra git nh zsh];
    text = ''
      set -e
      cd "$HOME"/nix
      git pull
      alejandra -q .
      git add .
      NIXOS_LABEL="$(date)" nh os switch "$HOME/nix"
      cd -
      rm -f ~/.zshenv
      exec zsh -l
    '';
  };
in {
  home.packages = [
    script
  ];
}
