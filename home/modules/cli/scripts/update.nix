{pkgs, ...}: let
  script = pkgs.writeShellApplication {
    name = "up";
    runtimeInputs = with pkgs; [alejandra git nh nushell];
    text = ''
      set -e
      cd "$HOME"/nix
      git pull
      alejandra -q .
      git add .
      NIXOS_LABEL="$(date)" nh os switch "$HOME/nix"
      cd -
      exec nu -l
    '';
  };
in {
  home.packages = [
    script
  ];
}
