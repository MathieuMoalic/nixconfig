{...}: {
  programs.btop = {
    enable = true;
    settings = {
      update_ms = 250;
      color_theme = "dracula";
      theme_background = false;
    };
  };
}
