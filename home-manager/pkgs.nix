{pkgs, ...}: {
  # here are packages that are not configured by home-manager.
  # other programs are installed in ./modules
  home.packages = with pkgs; [
    networkmanagerapplet

    # dev
    alejandra # format nix
    nil # nix LSP

    # GUI software
    zathura # pdf viewer
    anki-bin # flash cards
    brave # browser
    spotify # music

    # Windows Manager utilities
    rofi-bluetooth # bluetooth manager
    udiskie # automount usb
    nerdfonts # font
    fira-code # font
    pulseaudio # audio
    grimblast # screenshots
    hyprpaper # wallpaper
    brillo # brightness

    # Terminal and Shell utilities
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
  ];
}
