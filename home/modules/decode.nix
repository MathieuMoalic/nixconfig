{pkgs, ...}: let
  dec = pkgs.writeShellScriptBin "dec" ''
    if [ -z "$1" ]; then
      echo "No file specified"
      return 1
    fi

    if [ ! -f "$1" ]; then
        echo "Encrypted file not found: $1"
        return 1
    fi

    output=$1_$RANDOM
    ${pkgs.openssl}/bin/openssl enc -aes-256-cbc -d -salt -pbkdf2 -iter 100000 -in "$1" -out "$output"

    # Create a directory with the same name as the input file (without .encrypted)
    output_dir="''${1%.encrypted}"

    mkdir -p "$output_dir"

    # Extract the tarball contents into the newly created directory
    ${pkgs.gnutar}/bin/tar -xzf "$output" -C "$output_dir"
    rm "$output"
    echo "Decrypted $1 to $output_dir"

  '';
in {
  home.packages = [
    dec
  ];
}
