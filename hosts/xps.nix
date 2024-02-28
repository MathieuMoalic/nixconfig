{pkgs, ...}: {
  imports = [
    ./base.nix
    ./modules/sddm
    ./modules/syncthing.nix
    ./modules/desktop.nix
  ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
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
  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  # boot.swraid.enable = true;
  # boot.swraid.mdadmConf = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/fd49111d-571b-4f77-be35-d694f0e9f217";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-63890607-1aa3-4a8d-a666-6e0200eda2b4".device = "/dev/disk/by-uuid/63890607-1aa3-4a8d-a666-6e0200eda2b4";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/724A-1C0C";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/b280acec-cb05-4502-83cd-fd5dc35f7ed6";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp60s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  networking.hostName = "xps";
  system.stateVersion = "23.05";
}
