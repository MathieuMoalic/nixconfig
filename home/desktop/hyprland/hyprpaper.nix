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
            path = "/home/mat/.local/share/wallpaper.png";
            fit_mode = "cover";
          }
        ];
      };
    };
  };
}
