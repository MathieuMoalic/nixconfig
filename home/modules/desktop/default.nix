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
    inputs.hyprsome.packages.x86_64-linux.default
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
  # xdg.mimeApps = {
  #   enable = true;
  #   defaultApplications = {
  #     "image/png" = ["default1.desktop" "default2.desktop"];
  #   };
  # };
}
