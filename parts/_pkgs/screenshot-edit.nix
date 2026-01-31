{pkgs, ...}:
pkgs.writeShellApplication {
  name = "screenshot-edit";
  runtimeInputs = with pkgs; [grim slurp satty wl-clipboard];
  text = ''
    grim -g "$(slurp)" -t ppm - | satty --filename - --output-filename "$HOME/dl/screenshot-$(date '+%Y%m%d-%H:%M:%S').png" --initial-tool brush --copy-command wl-copy'';
}
