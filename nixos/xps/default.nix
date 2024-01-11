{...}: {
  imports = [
    ./hardware-configuration.nix
    ../base.nix
    ../modules/sddm
  ];
  # Setup keyfile
  boot.initrd.secrets = {"/crypto_keyfile.bin" = null;};

  # Enable swap on luks
  boot.initrd.luks.devices."luks-697ee5de-1a53-475e-9285-19fbc72bc068".device = "/dev/disk/by-uuid/697ee5de-1a53-475e-9285-19fbc72bc068";
  boot.initrd.luks.devices."luks-697ee5de-1a53-475e-9285-19fbc72bc068".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "xps";
}
