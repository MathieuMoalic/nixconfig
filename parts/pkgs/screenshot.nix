{
  lib,
  config,
  ...
}: let
  overlay = final: prev: {
    screenshot = final.writeShellApplication {
      name = "screenshot";
      runtimeInputs = with final; [grim slurp wl-clipboard];
      text = ''
        grim -g "$(slurp)" - | wl-copy --type image/png
      '';
    };
  };
in {
  my.overlays = lib.mkAfter [overlay];
  perSystem = {system, ...}: let pkgs = config.my.mkPkgs system; in {packages.screenshot = pkgs.screenshot;};
}
