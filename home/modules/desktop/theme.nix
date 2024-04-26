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

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };
}
