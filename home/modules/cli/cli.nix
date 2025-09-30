{pkgs, ...}: {
  imports = [
    ./yazi.nix
    ./zellij.nix
    ./aliases.nix
    ./btop.nix
    ./direnv.nix
    ./git.nix
    ./helix.nix
    ./lazygit.nix
    ./rclone.nix
    ./ssh.nix
    ./starship.nix
    ./fish.nix
    ./nvim.nix
  ];
  home.packages = with pkgs; [
    uutils-coreutils-noprefix

    exiftool # file details
    bat-extras.batman # man
    trash-cli # trash
    funzzy # watch files
    github-cli # gh
    wget # download
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
    trippy # network diagnostic tool
    procs # process viewer
    gitui # git TUI
    nh # nix helper
    comma # wraps together nix shell -c and nix-index
    delta # diff
    just # makefile in rust
    alejandra # format nix
    nixd # nix LSP

    # custom scripts below
    decode
    encode
    lnmv
    nix-run
    nix-shell
    update
    journalctl
    sopsedit
  ];
}
