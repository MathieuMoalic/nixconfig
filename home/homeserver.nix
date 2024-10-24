{pkgs, ...}: {
  imports = [
    ./modules/base.nix
    ./modules/cli/cli.nix
    ./modules/dev/dev.nix
  ];
  home.packages = with pkgs; [
    caddy
  ];
  home.stateVersion = "23.11";
}
