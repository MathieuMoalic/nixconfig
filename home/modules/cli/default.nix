{pkgs, ...}: {
  imports = [
    ./scripts
    ./aliases.nix
    ./atuin.nix
    ./btop.nix
    ./direnv.nix
    ./dunst.nix
    ./git.nix
    ./helix.nix
    ./lazygit.nix
    ./pager.nix
    ./rclone.nix
    ./ssh.nix
    ./starship.nix
    ./yazi.nix
    ./zellij.nix
    ./zsh.nix
  ];
  home.packages = with pkgs; [
    bat-extras.batman # man
    trash-cli # trash
    funzzy # watch files
    github-cli # gh
    wget # download
    zsh # shell
    zoxide # a smarter cd in rust
    skim # fuzzy finder `sk`
    ouch # de-compress files
    ripgrep # grep in rust
    tealdeer # tldr in rust
    bat # cat in rust
    fd # find in rust
    du-dust # du in rust
    duf # df in rust
    eza # ls in rust
    neofetch # flex
    sops # secrets manager
    mosh # ssh
    hexyl # hexdump
    netscanner # network scanner TUI
    bandwhich # network bandwidth TUI
    procs # process viewer
    gitui # git TUI
  ];
}
