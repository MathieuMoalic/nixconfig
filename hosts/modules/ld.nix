{pkgs, ...}: {
  programs.nix-ld = {
    enable = true;
    # This is the default value
    libraries = [
      zlib
      zstd
      stdenv.cc.cc
      curl
      openssl
      attr
      libssh
      bzip2
      libxml2
      acl
      libsodium
      util-linux
      xz
      systemd
    ];
  };
}
