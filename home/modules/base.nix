{inputs, ...}: {
  imports = [
    ./nix-settings.nix
    ./session-variables.nix
    ./user-dirs.nix
    ./colorscheme.nix
    inputs.nix-colors.homeManagerModules.default
    inputs.nvf.homeManagerModules.default
    inputs.nix-index-database.homeModules.nix-index
  ];

  systemd.user.startServices = "sd-switch";
}
