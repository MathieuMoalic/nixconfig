{...}: let
  overlay = final: _: {
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
  flake.overlays.lock = overlay;
}
