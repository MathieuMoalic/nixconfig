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
    inputs.amumax.packages.x86_64-linux.amumax
    inputs.mx3expend.packages.${pkgs.system}.mx3expend
    nvtop-nvidia
    caddy # web server
    blender # 3d editor
  ];
  home.stateVersion = "23.05";
}
