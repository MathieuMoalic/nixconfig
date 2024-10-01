{...}: {
  # .desktop files are saved in /etc/profiles/per-user/mat/share/applications/
  xdg.mimeApps = {
    enable = true;
    # This changes $XDG_CONFIG_HOME/mimeapps.list
    defaultApplications = {
      "application/pdf" = "librewolf.desktop";
      "image/avif" = "org.nomacs.ImageLounge.desktop";
      "image/bmp" = "org.nomacs.ImageLounge.desktop";
      "image/gif" = "org.nomacs.ImageLounge.desktop";
      "image/heic" = "org.nomacs.ImageLounge.desktop";
      "image/heif" = "org.nomacs.ImageLounge.desktop";
      "image/jpeg" = "org.nomacs.ImageLounge.desktop";
      "image/jxl" = "org.nomacs.ImageLounge.desktop";
      "image/png" = "org.nomacs.ImageLounge.desktop";
      "image/tiff" = "org.nomacs.ImageLounge.desktop";
      "image/webp" = "org.nomacs.ImageLounge.desktop";
      "image/x-eps" = "org.nomacs.ImageLounge.desktop";
      "image/x-ico" = "org.nomacs.ImageLounge.desktop";
      "image/x-portable-bitmap" = "org.nomacs.ImageLounge.desktop";
      "image/x-portable-graymap" = "org.nomacs.ImageLounge.desktop";
      "image/x-portable-pixmap" = "org.nomacs.ImageLounge.desktop";
      "image/x-xbitmap" = "org.nomacs.ImageLounge.desktop";
      "image/x-xpixmap" = "org.nomacs.ImageLounge.desktop";
    };
  };
}
