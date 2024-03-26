{pkgs, ...}: let
  nh = pkgs.writeShellScriptBin "nh" ''
    nohup "$@" > /dev/null 2>&1 &
  '';
in {
  home.packages = [
    nh
  ];
}
