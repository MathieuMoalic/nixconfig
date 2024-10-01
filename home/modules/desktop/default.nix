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
    ./mimeapps.nix
  ];
  home.packages = with pkgs; [
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
    spotify # music
    localsend # send files
  ];
  home.shellAliases = {
    rd = "ripdrag -x";
  };
}
