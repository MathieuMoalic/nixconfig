{...}: let
  overlay = final: _: {
    update = final.writeShellApplication {
      name = "up";
      runtimeInputs = with final; [alejandra git nh];
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
    };
  };
in {
  flake.overlays.update = overlay;
}
