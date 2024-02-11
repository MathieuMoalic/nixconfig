{config, ...}: {
  programs.zathura = with config.colorScheme.palette; {
    enable = true;
    options = {
      ### Settings from original zathurarc ###
      # pages-per-row = "1";
      # scroll-page-aware = "true";
      # scroll-full-overlap = "0.01";
      # scroll-step = "100";
      # font = "Source Code Pro 11";
      recolor = "true";
      # Don't allow original hue when recoloring
      recolor-keephue = "true";
      # Don't keep original image colors while recoloring
      recolor-reverse-video = "false";
      # Command line completion entries
      completion-fg = "#c0caf5";
      completion-bg = "#${base00}";
      # Command line completion group elements
      completion-group-fg = "#7aa2f7";
      completion-group-bg = "#${base00}";
      # Current command line completion element
      completion-highlight-fg = "#1a1b26";
      completion-highlight-bg = "#${base00}";
      # Default foreground/background color
      default-bg = "rgba(26, 27, 38, 0.95)";
      # Input bar
      inputbar-fg = "#c0caf5";
      inputbar-bg = "#${base00}";
      # Notification
      notification-fg = "#c0caf5";
      notification-bg = "#${base00}";
      # Error notification
      notification-error-fg = "#c0caf5";
      notification-error-bg = "#${base00}";
      # Warning notification
      notification-warning-fg = "#c0caf5";
      notification-warning-bg = "#${base00}";
      # Status bar
      statusbar-fg = "#c0caf5";
      statusbar-bg = "#${base00}";
      # Highlighting parts of the document (e.g. show search results)
      highlight-color = "#7aa2f7";
      highlight-active-color = "#7aa2f7";
      # Represent light/dark colors in recoloring mode
      recolor-lightcolor = "#dcdccc";
      recolor-darkcolor = "#1f1f1f";
      # 'Loading...' text
      render-loading-fg = "#c0caf5";
      render-loading-bg = "#1a1b26";
      # Index mode
      index-fg = "#c0caf5";
      index-bg = "#1a1b26";
      # Selected element in index mode
      index-active-fg = "#1a1b26";
      index-active-bg = "#c0caf5";
    };
  };
}
