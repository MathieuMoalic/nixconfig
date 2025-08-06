{...}: {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = ["/home/mat/.local/share/wallpaper.png"];
      wallpaper = [",/home/mat/.local/share/wallpaper.png"];
    };
  };
}
