{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./modules
    ./modules/cli
    ./modules/dev
  ];
  home.packages = with pkgs; [
    inputs.amumax.packages.${pkgs.system}.amumax
    inputs.mx3expend.packages.${pkgs.system}.mx3expend
    nvtopPackages.nvidia
    caddy # web server
  ];
  home.stateVersion = "24.05";
}
