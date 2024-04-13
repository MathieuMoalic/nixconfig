{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    ./hyprland
    ./scripts
    ./bluetooth.nix
    ./foot.nix
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
    rofi-bluetooth # bluetooth manager
    udiskie # automount usb
    pulseaudio # audio
    grimblast # screenshots
    hyprpaper # wallpaper
    brillo # brightness
    libnotify # notifications
    wl-clipboard # wayland clipboard

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
  ];
}
