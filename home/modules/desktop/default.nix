{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hyprland
    ./scripts
    ./bluetooth.nix
    ./foot.nix
    ./librewolf.nix
    ./rofi.nix
    ./theme.nix
    ./vscode.nix
    ./waybar.nix
    ./xdg-desktop-entries.nix
    ./zathura.nix
  ];
  home.packages = with pkgs; [
    hyprlock
    hypridle
    inputs.hyprsome.packages.${pkgs.system}.default
    rofi-wayland # command runner
    rofi-bluetooth # bluetooth manager
    udiskie # automount usb
    pulseaudio # audio
    grimblast # screenshots
    hyprpaper # wallpaper
    brillo # brightness
    libnotify # notifications
    wl-clipboard # wayland clipboard
    ripdrag # ripgrep + drag and drop

    inputs.quicktranslate.packages.${pkgs.system}.quicktranslate
    libreoffice # document editor
    teams-for-linux # chat
    mpv # video player
    gimp # image editor
    inkscape # svf editor
    nomacs # image viewer
    zathura # pdf viewer
    anki-bin # flash cards
    librewolf # browser
    spotify # music
    vscode # editor
    localsend # send files
  ];
  home.shellAliases = {
    rd = "ripdrag -x";
  };
  # Saved in /etc/profiles/per-user/mat/share/applications/
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
