{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./modules/base.nix
    ./modules/cli/cli.nix
    ./modules/dev/dev.nix
    ./modules/desktop/desktop.nix
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
