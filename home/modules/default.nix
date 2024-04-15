{config, ...}: {
  imports = [
    ./nix-settings.nix
    ./session-variables.nix
    ./user-dirs.nix
  ];

  systemd.user.startServices = "sd-switch";
}
