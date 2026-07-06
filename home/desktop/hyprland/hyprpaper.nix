{
  flake.homeModules.hyprpaper = {...}: {
    services.hyprpaper = {
      enable = true;

      settings = {
        ipc = true;
        splash = false;
        wallpaper = [
          {
            monitor = "";
            path = "/home/mat/.local/share/wallpaper.jpg";
            fit_mode = "cover";
          }
        ];
      };
    };
  };
}
