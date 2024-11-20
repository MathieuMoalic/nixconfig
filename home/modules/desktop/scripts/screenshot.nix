{pkgs, ...}:
pkgs.writeShellApplication {
  name = "sc";
  runtimeInputs = with pkgs; [grim slurp satty wl-clipboard];
  text = ''
    grim -g "$(slurp)" -t ppm - | satty --filename - \
    --output-filename /tmp/satty-"$(date '+%Y%m%d-%H:%M:%S')".png \
    --initial-tool brush --copy-command wl-copy --early-exit'';
}
