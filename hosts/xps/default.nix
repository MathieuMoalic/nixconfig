{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../base.nix
    ../modules/sddm
    ../modules/syncthing.nix
  ];
  # for brillo (1st line) and xremap (2nd line)
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
    KERNEL=="uinput", GROUP="input", TAG+="uaccess"
  '';
  hardware.brillo.enable = true;
  # hardware.uinput.enable = true; # for xremap
  powerManagement.powertop.enable = true;

  # Setup keyfile
  boot.initrd.secrets = {"/crypto_keyfile.bin" = null;};

  # Enable swap on luks
  boot.initrd.luks.devices."luks-697ee5de-1a53-475e-9285-19fbc72bc068".device = "/dev/disk/by-uuid/697ee5de-1a53-475e-9285-19fbc72bc068";
  boot.initrd.luks.devices."luks-697ee5de-1a53-475e-9285-19fbc72bc068".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "xps";
  system.stateVersion = "23.05";
}
