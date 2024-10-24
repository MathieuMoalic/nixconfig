{pkgs, ...}: {
  imports = [
    ./modules/base.nix
    ./modules/cli/cli.nix
    ./modules/dev/dev.nix
    ./modules/desktop/desktop.nix
  ];
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    nvtopPackages.amd
    wootility
  ];
}
