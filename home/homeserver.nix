{pkgs, ...}: {
  imports = [
    ./modules/base.nix
    ./modules/cli/cli.nix
  ];
  home.packages = with pkgs; [
    caddy
    slirp4netns
  ];
  home.stateVersion = "23.11";
}
