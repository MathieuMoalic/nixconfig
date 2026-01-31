{pkgs, ...}:
pkgs.writeShellApplication {
  name = "up";
  runtimeInputs = with pkgs; [alejandra git nh];
  text = ''
    set -e
    cd "$HOME"/nix
    git pull
    alejandra -q .
    git add .
    NIXOS_LABEL="$(date)" nh os switch "$HOME/nix"
    cd -
    rm -rf "$HOME/.icons"
    rm -rf "$HOME/.manpath"
  '';
}
