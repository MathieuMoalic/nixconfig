{
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.settings.exec-once = lib.mkAfter [
    "${pkgs.hyprpaper}/bin/hyprpaper"
  ];
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = ["/home/mat/.local/share/wallpaper.png"];
      wallpaper = [",/home/mat/.local/share/wallpaper.png"];
    };
  };
}
