{pkgs, ...}:
pkgs.writeShellApplication {
  name = "lnmv";
  text = ''mv "$1" "$1.bak" && cat "$1.bak" > "$1"'';
}
