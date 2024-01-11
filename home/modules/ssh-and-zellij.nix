{pkgs, ...}: let
  s = pkgs.writeShellScriptBin "s" ''
    ssh $1 -o RequestTTY=yes -o RemoteCommand="zellij a -c 1"
  '';
in {
  home.packages = [
    s
  ];
}
