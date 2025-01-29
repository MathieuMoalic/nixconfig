{pkgs, ...}:
pkgs.writeShellApplication {
  name = "screenshot";
  runtimeInputs = with pkgs; [grim slurp wl-clipboard];
  text = ''
    grim -g "$(slurp)" - | wl-copy --type image/png
  '';
}
