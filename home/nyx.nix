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
    "[workspace 21 silent] ${pkgs.foot}/bin/foot zellij a 1"
    "[workspace 2 silent] ${pkgs.vscode}/bin/code"
    "[workspace 11 silent] ${pkgs.librewolf}/bin/librewolf"
  ];
  home.stateVersion = "23.05";
}
