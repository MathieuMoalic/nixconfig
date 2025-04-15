{pkgs, ...}: {
  imports = [
    ./hyprland/hyprland.nix
    ./bluetooth.nix
    ./foot.nix
    ./librewolf.nix
    ./rofi.nix
    ./theme.nix
    ./waybar.nix
    ./zathura.nix
    ./mimeapps.nix
    ./dunst.nix
  ];
  home.packages = with pkgs; [
    rofi-bluetooth # bluetooth manager
    pulseaudio # audio
    brillo # brightness
    libnotify # notifications
    wl-clipboard # wayland clipboard
    ripdrag # ripgrep + drag and drop
    vscode # code editor

    libreoffice # document editor
    teams-for-linux # chat
    mpv # video player
    gimp # image editor
    inkscape # svf editor
    nomacs # image viewer
    zathura # pdf viewer
    anki-bin # flash cards
    freetube # youtube client
  ];
  programs.nushell.shellAliases = {
    rd = "ripdrag -x";
  };
}
