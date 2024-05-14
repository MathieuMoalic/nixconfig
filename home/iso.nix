{
  inputs,
  pkgs,
  osConfig,
  lib,
  ...
}: {
  imports = [
    ./modules
    ./modules/cli
    ./modules/dev
    ./modules/desktop
  ];
  home.stateVersion = "23.11";
}
