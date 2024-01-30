{
  inputs,
  pkgs,
  osConfig,
  lib,
  ...
}: {
  # here are packages that are not configured by home-manager.
  # other programs are installed in ./modules
  home.packages = with pkgs;
    [
      # dev
      just # makefile in rust
      alejandra # format nix
      nil # nix LSP
      poetry # python packages
      ruff-lsp # python lsp
      ruff #python formatter
      taplo # toml LSP
      dockerfile-language-server-nodejs # dockerfile lsp

      # GUI software
      inputs.quicktranslate.packages.${pkgs.system}.quicktranslate
      onlyoffice-bin # document editor
      mpv # video player
      gimp # image editor
      inkscape # svf editor
      nomacs # image viewer
      zathura # pdf viewer
      anki-bin # flash cards
      brave # browser
      spotify # music
      vscode # editor

      # Windows Manager utilities
      inputs.hyprsome.packages.x86_64-linux.default
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
      sops # secrets manager
    ]
    ++ (lib.optionals (osConfig.networking.hostName == "nyx") [
      inputs.amumax.packages.x86_64-linux.amumax
      inputs.mx3expend.packages.${pkgs.system}.mx3expend
    ]);
}
