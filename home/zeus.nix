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
  home.packages = with pkgs; [
    inputs.amumax.packages.x86_64-linux.amumax
    inputs.mx3expend.packages.${pkgs.system}.mx3expend
    nvtopPackages.nvidia
    caddy
  ];
  home.stateVersion = "23.11";
}
