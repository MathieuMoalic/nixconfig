{pkgs, ...}: let
  script = pkgs.writeShellApplication {
    name = "nh";
    text = ''nohup "$@" > /dev/null 2>&1 &'';
  };
in {
  home.packages = [
    script
  ];
}
