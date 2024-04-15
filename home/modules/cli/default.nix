{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
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
    ./ssh.nix
    ./starship.nix
    ./yazi.nix
    ./zellij.nix
    ./zsh.nix
  ];
  home.packages = with pkgs; [
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
    ripgrep # grep in rust
    tealdeer # tldr in rust
    bat # cat in rust
    fd # find in rust
    du-dust # du in rust
    duf # df in rust
    eza # ls in rust
    neofetch # flex
    sops # secrets manager
    rclone # sync
    mosh # ssh
  ];
}