{
  amumax,
  pkgs,
  ...
}: {
  # here are packages that are not configured by home-manager.
  # other programs are installed in ./modules
  home.packages = with pkgs; [
    amumax.packages.x86_64-linux.amumax
    networkmanagerapplet

    # dev
    just # makefile in rust
    alejandra # format nix
    nil # nix LSP

    # GUI software
    onlyoffice-bin # document editor
    mpv # video player
    inkscape # svf editor
    nomacs # image viewer
    zathura # pdf viewer
    anki-bin # flash cards
    brave # browser
    spotify # music
    vscode # editor

    # Windows Manager utilities
    rofi-bluetooth # bluetooth manager
    udiskie # automount usb
    pulseaudio # audio
    grimblast # screenshots
    hyprpaper # wallpaper
    brillo # brightness

    # Terminal and Shell utilities
    bat-extras.batman # man
    trash-cli # trash
    entr # watch files
    github-cli # gh
    wget # download
    zsh # shell
    zoxide # a smarter cd in rust
    skim # fuzzy finder `sk`
    ripdrag # ripgrep + drag and drop
    ouch # de-compress files
    tealdeer # tldr in rust
    bat # cat in rust
    fd # find in rust
    du-dust # du in rust
    duf # df in rust
    eza # ls in rust
    neofetch # flex
  ];
}
