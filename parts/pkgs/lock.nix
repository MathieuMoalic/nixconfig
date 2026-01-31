{
  lib,
  config,
  ...
}: let
  overlay = final: prev: {
    lock = final.writeShellApplication {
      name = "lock";
      runtimeInputs = with final; [hyprlock hyprland];
      text = ''
        hyprlock &
        sleep 1
        hyprctl dispatch dpms off
      '';
    };
  };
in {
  my.overlays = lib.mkAfter [overlay];
  perSystem = {system, ...}: let pkgs = config.my.mkPkgs system; in {packages.lock = pkgs.lock;};
}
