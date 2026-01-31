{
  lib,
  config,
  ...
}: let
  overlay = final: prev: {
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
  my.overlays = lib.mkAfter [overlay];
  perSystem = {system, ...}: let pkgs = config.my.mkPkgs system; in {packages.update = pkgs.update;};
}
