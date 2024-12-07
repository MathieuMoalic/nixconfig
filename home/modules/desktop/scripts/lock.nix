{pkgs, ...}:
pkgs.writeShellApplication {
  name = "lock";
  runtimeInputs = with pkgs; [hyprlock hyprland];
  text = ''
    hyprlock &
    sleep 1
    hyprctl dispatch dpms off
  '';
}
