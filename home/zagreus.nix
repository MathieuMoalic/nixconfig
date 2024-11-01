{
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
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    nvtopPackages.amd
    wootility
    element-desktop-wayland
  ];
  wayland.windowManager.hyprland.settings.exec-once = lib.mkAfter [
    "[workspace 1 silent] ${pkgs.librewolf}/bin/librewolf"
    "[workspace 3 silent] ${pkgs.steam}/bin/steam"
  ];
}
