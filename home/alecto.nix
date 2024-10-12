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
  ];
  home.stateVersion = "24.05";
}
