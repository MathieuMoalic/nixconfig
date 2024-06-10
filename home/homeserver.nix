{pkgs, ...}: {
  imports = [
    ./modules
    ./modules/cli
    ./modules/dev
  ];
  home.packages = with pkgs; [
    caddy
  ];
  home.stateVersion = "23.11";
}
