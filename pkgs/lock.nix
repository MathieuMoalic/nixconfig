{
  flake.overlays.lock = final: _: {
    lock = final.writeShellApplication {
      name = "lock";
      runtimeInputs = with final; [hyprland];
      text = ''
        sleep 1
        hyprctl dispatch dpms off
      '';
    };
  };
}
