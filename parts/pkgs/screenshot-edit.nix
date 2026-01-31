{
  lib,
  config,
  ...
}: let
  overlay = final: prev: {
    "screenshot-edit" = final.writeShellApplication {
      name = "screenshot-edit";
      runtimeInputs = with final; [grim slurp satty wl-clipboard];
      text = ''
        grim -g "$(slurp)" -t ppm - | satty --filename - --output-filename "$HOME/dl/screenshot-$(date '+%Y%m%d-%H:%M:%S').png" --initial-tool brush --copy-command wl-copy'';
    };
  };
in {
  my.overlays = lib.mkAfter [overlay];
  perSystem = {system, ...}: let pkgs = config.my.mkPkgs system; in {packages."screenshot-edit" = pkgs."screenshot-edit";};
}
