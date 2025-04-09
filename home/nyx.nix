{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./modules/base.nix
    ./modules/cli/cli.nix
    ./modules/dev/dev.nix
    ./modules/desktop/desktop.nix
  ];
  home.packages = with pkgs; [
    inputs.amumax.packages.${pkgs.system}.default
    nvtopPackages.nvidia
    caddy # web server
    blender # 3d editor
    remmina # rdc
  ];
  wayland.windowManager.hyprland.settings.exec-once = lib.mkAfter [
    "[workspace 21 silent] ${pkgs.foot}/bin/foot zellij a 1"
    "[workspace 2 silent] ${pkgs.vscode}/bin/code"
    "[workspace 11 silent] ${pkgs.librewolf}/bin/librewolf"
    "[workspace 13 silent] ${pkgs.teams-for-linux}/bin/teams-for-linux"
  ];
  home.stateVersion = "23.05";
}
