{pkgs, ...}: let
  script = pkgs.writeShellApplication {
    name = "lnmv";
    text = ''mv "$1" "$1.bak" && cat "$1.bak" > "$1"'';
  };
in {
  home.packages = [
    script
  ];
}
