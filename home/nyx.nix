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
    "[workspace 1 silent] ${pkgs.vscode}/bin/code"
    "[workspace 11] ${pkgs.librewolf}/bin/librewolf"
    "[workspace 21] ${pkgs.foot}/bin/foot"
    "[workspace 13 silent] ${pkgs.teams-for-linux}/bin/teams-for-linux"
  ];
  home.stateVersion = "23.05";
}
