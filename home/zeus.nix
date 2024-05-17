{
  inputs,
  pkgs,
  osConfig,
  lib,
  config,
  ...
}: {
  imports = [
    ./modules
    ./modules/cli
    ./modules/dev
  ];
  home.stateVersion = "23.11";
}
