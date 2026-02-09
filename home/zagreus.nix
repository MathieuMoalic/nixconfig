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
    lutris
  ];
  wayland.windowManager.hyprland.settings.exec-once = lib.mkAfter [
    "[workspace 1 silent] ${pkgs.librewolf}/bin/librewolf"
    "[workspace 2 silent] ${pkgs.steam}/bin/steam"
    "[workspace 3 silent] ${pkgs.deezer-enhanced}/bin/deezer-enhanced"
  ];
}
