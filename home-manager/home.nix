{inputs, ...}: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./pkgs.nix
    ./modules/theme.nix
    ./modules/quick-translate.nix
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
    # ./modules/direnv.nix
    # ./modules/syncthing.nix
  ];
  programs.ripgrep.enable = true;
  services.mpris-proxy.enable = true; # pause/play bluetooth commands

  home.username = "mat";
  home.homeDirectory = "/home/mat";

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
