{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./modules/base.nix
    ./modules/cli/cli.nix
    ./modules/desktop/desktop.nix
  ];
  home.packages = with pkgs; [
    amumax
    nvtopPackages.nvidia
    caddy # web server
    blender # 3d editor
    remmina # rdc
  ];
  wayland.windowManager.hyprland.settings.exec-once = lib.mkAfter [
    "[workspace 21 silent] ${pkgs.wezterm}/bin/wezterm zellij a 1"
    "[workspace 11 silent] ${pkgs.librewolf}/bin/librewolf"
  ];
  home.stateVersion = "23.05";
}
