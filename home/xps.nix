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
    ./modules/desktop
    ./modules/dev
  ];
  home.packages = with pkgs; [
  ];
  home.stateVersion = "23.05";
}
