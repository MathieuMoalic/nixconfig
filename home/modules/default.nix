{config, ...}: {
  imports = [
    ./nix-settings.nix
    ./session-variables.nix
    ./user-dirs.nix
    ./colorscheme.nix
  ];

  systemd.user.startServices = "sd-switch";
}
