{pkgs, ...}: let
  lock = pkgs.writeShellScriptBin "lock" ''
    ${pkgs.hyprlock}/bin/hyprlock &
    sleep 1
    ${pkgs.hyprland}/bin/hyprctl dispatch dpms off
  '';
in {
  home.packages = [
    lock
  ];
}
