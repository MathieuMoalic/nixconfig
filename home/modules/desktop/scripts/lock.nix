{pkgs, ...}: let
  script = pkgs.writeShellApplication {
    name = "lock";
    text = ''
      ${pkgs.hyprlock}/bin/hyprlock &
      sleep 1
      ${pkgs.hyprland}/bin/hyprctl dispatch dpms off
    '';
  };
in {
  home.packages = [
    script
  ];
}
