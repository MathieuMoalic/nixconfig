{...}: {
  imports = [
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
  ];
  wayland.windowManager.hyprland.enable = true;
}
