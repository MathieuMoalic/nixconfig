{...}: {
  imports = [
    ./modules/base.nix
    ./modules/cli/cli.nix
    ./modules/dev/dev.nix
  ];
  home.stateVersion = "23.11";
}
