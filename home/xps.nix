{...}: {
  imports = [
    ./modules
    ./modules/cli
    ./modules/desktop
    ./modules/dev
    ./modules/ags.nix
  ];
  home.stateVersion = "23.05";
}
