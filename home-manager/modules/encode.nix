{pkgs, ...}: let
  enc = pkgs.writeShellScriptBin "enc" ''
        if [ -z \"$1\" ]; then
        echo \"o directory specified\"
        return 1
    fi

    if [ ! -d \"$1\" ]; then
        echo \"irectory not found: $1\"
        return 1
    fi

    tar -czf \"$1.tar.gz\" -C \"$1\" .
    openssl enc -aes-256-cbc -salt -pbkdf2 -iter 100000 -in \"$1.tar.gz\" -out \"$1.encrypted\"
    \rm \"$1.tar.gz\"
    echo \"ncrypted $1 to $1.encrypted\"
  '';
in {
  home.packages = [
    enc
  ];
}
