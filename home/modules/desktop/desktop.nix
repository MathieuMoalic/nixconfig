{pkgs, ...}: {
  imports = [
    ./hyprland/hyprland.nix
    ./bluetooth.nix
    ./wezterm.nix
    ./librewolf.nix
    ./rofi.nix
    ./theme.nix
    ./zathura.nix
    ./mimeapps.nix
  ];
  home.packages = with pkgs; [
    grim
    rofi-bluetooth # bluetooth manager
    pulseaudio # audio
    brillo # brightness
    libnotify # notifications
    wl-clipboard # wayland clipboard
    ripdrag # ripgrep + drag and drop
    vscode # code editor
    codex

    libreoffice # document editor
    mpv # video player
    gimp # image editor
    inkscape # svf editor
    nomacs # image viewer
    zathura # pdf viewer
    anki-bin # flash cards
    freetube # youtube client
    hyprpanel
  ];
  programs.fish.shellAliases = {
    rd = "ripdrag -x";
  };
}
