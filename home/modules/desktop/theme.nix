{
  config,
  pkgs,
  ...
}: {
  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    cursorTheme.package = pkgs.graphite-cursors;
    cursorTheme.name = "graphite-dark";

    theme.package = pkgs.adw-gtk3;
    theme.name = "adw-gtk3";
  };
  home.pointerCursor = {
    package = pkgs.graphite-cursors;
    gtk.enable = true;
    name = "graphite-dark";
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };
}
