{...}: {
  imports = [
    ./modules/base.nix
    ./modules/cli/cli.nix
    ./modules/desktop/desktop.nix
  ];
  home.stateVersion = "23.05";
}
