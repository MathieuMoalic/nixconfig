{
  flake.homeModules.theme = {
    config,
    pkgs,
    ...
  }: {
    gtk = {
      enable = true;
      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      gtk4.theme = null;
      theme.package = pkgs.adw-gtk3;
      theme.name = "adw-gtk3";
    };

    # Hyprland needs the Hyprcursor-format package separately.
    home.packages = [
      pkgs.rose-pine-hyprcursor
    ];

    # X11/XWayland + GTK use the regular XCursor package.
    home.pointerCursor = {
      enable = true;
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
      size = 32;

      gtk.enable = true;
      x11.enable = true;
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style.name = "adwaita-dark";
      style.package = pkgs.adwaita-qt;
    };
  };
}
