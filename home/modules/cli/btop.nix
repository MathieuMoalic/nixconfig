{...}: {
  programs.btop = {
    enable = true;
    settings = {
      update_ms = 1000;
      color_theme = "dracula";
      theme_background = false;
    };
  };
}
