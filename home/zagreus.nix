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
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    nvtopPackages.amd
    wootility
  ];
  wayland.windowManager.hyprland.settings.exec-once = lib.mkAfter [
    "[workspace 11 silent] ${pkgs.librewolf}/bin/librewolf"
    "[workspace 12 silent] ${pkgs.steam}/bin/steam"
  ];
}
