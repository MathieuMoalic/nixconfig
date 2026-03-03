{
  flake.overlays.screenshot = final: _: {
    screenshot = final.writeShellApplication {
      name = "screenshot";
      runtimeInputs = with final; [grim slurp wl-clipboard];
      text = ''
        grim -g "$(slurp)" - | wl-copy --type image/png
      '';
    };
  };
}
