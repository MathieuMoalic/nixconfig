{
  inputs,
  osConfig,
  ...
}: {
  imports = [
    ./pkgs.nix
    ./modules/vscode.nix
    ./modules/direnv.nix
    ./modules/nix-dev.nix
    ./modules/lazygit.nix
    ./modules/ssh.nix
    ./modules/ssh-and-zellij.nix
    ./modules/update.nix
    ./modules/theme.nix
    ./modules/decode.nix
    ./modules/encode.nix
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
    ./modules/wifi-menu.nix
    ./modules/power-menu.nix
    ./modules/pager.nix
    ./modules/wireguard-menu.nix
    ./modules/hyprland.nix
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
