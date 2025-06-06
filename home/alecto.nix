{...}: {
  imports = [
    ./modules/base.nix
    ./modules/cli/cli.nix
  ];
  home.stateVersion = "24.05";
}
