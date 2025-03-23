{...}: {
  imports = [
    ./nix-settings.nix
    ./session-variables.nix
    ./user-dirs.nix
    ./colorscheme.nix
    ./nvim.nix
  ];

  systemd.user.startServices = "sd-switch";
}
