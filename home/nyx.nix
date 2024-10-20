{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./modules
    ./modules/cli
    ./modules/desktop
    ./modules/dev
  ];
  home.packages = with pkgs; [
    inputs.amumax.packages.${pkgs.system}.git
    nvtopPackages.nvidia
    caddy # web server
    blender # 3d editor
    remmina # rdc
  ];
  home.stateVersion = "23.05";
}
