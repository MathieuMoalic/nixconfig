{pkgs, ...}: {
  imports = [
    ./modules
    ./modules/cli
    ./modules/desktop
    ./modules/dev
  ];
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    nvtopPackages.amd
    wootility
  ];
}
