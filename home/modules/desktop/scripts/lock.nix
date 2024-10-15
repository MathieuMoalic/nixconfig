{pkgs, ...}: let
  script = pkgs.writeShellApplication {
    name = "lock";
    runtimeInputs = with pkgs; [hyprlock hyprland];
    text = ''
      hyprlock &
      sleep 1
      hyprctl dispatch dpms off
    '';
  };
in {
  home.packages = [
    script
  ];
}
