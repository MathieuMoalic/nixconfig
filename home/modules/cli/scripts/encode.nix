{pkgs, ...}: let
  script = pkgs.writeShellApplication {
    name = "enc";
    text = ''
          set -e
      if [ -z "$1" ]; then
        echo No directory specified
        return 1
      fi

      if [ ! -d "$1" ]; then
        echo Directory not found: "$1"
        return 1
      fi

      ${pkgs.gnutar}/bin/tar -czf "$1.tar.gz" -C "$1" .
      ${pkgs.openssl}/bin/openssl enc -aes-256-cbc -salt -pbkdf2 -iter 100000 -in "$1.tar.gz" -out "$1.encrypted"
      rm "$1.tar.gz"
      echo "Encrypted $1 to $1.encrypted"
    '';
  };
in {
  home.packages = [
    script
  ];
}
