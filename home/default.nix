{
  inputs,
  osConfig,
  ...
}: {
  imports = [
    ./pkgs.nix
    ./modules/scripts/decode.nix
    ./modules/scripts/encode.nix
    ./modules/scripts/nh.nix
    ./modules/scripts/nix-dev.nix
    ./modules/scripts/power-menu.nix
    ./modules/scripts/ssh-and-zellij.nix
    ./modules/scripts/update.nix
    ./modules/scripts/wifi-menu.nix
    ./modules/scripts/wireguard-menu.nix

    ./modules/vscode.nix
    ./modules/direnv.nix
    ./modules/lazygit.nix
    ./modules/ssh.nix
    ./modules/theme.nix
    ./modules/nix.nix
    ./modules/atuin.nix
    ./modules/dunst.nix
    ./modules/foot.nix
    ./modules/helix.nix
    ./modules/rofi.nix
    ./modules/swaylock.nix
    ./modules/waybar.nix
    ./modules/zellij.nix
    ./modules/btop.nix
    ./modules/git.nix
    ./modules/starship.nix
    ./modules/xdg.nix
    ./modules/yazi.nix
    ./modules/pager.nix
    ./modules/hyprland
    ./modules/swayidle.nix
    ./modules/zathura.nix
    ./modules/zsh.nix
    ./modules/aliases.nix
    ./modules/session-variables.nix
  ];

  programs.ripgrep.enable = true;
  services.mpris-proxy.enable = true; # pause/play bluetooth commands
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "23.05";
  nixpkgs.config.allowUnfree = true;
  # home.files."wad".source = osConfig.sops.secrets.exemple_key.path;
}
