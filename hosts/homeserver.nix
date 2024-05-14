{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./base.nix
    ./modules/syncthing.nix
  ];

  # Setup keyfile
  boot.initrd.secrets = {"/crypto_keyfile.bin" = null;};

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9e971c2a-60f3-44e5-a1d2-7a963445105b";
    fsType = "ext4";
  };

  # swapDevices = [
  #   {device = "/dev/disk/by-uuid/b280acec-cb05-4502-83cd-fd5dc35f7ed6";}
  # ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  networking.hostName = "homeserver";
  system.stateVersion = "23.11";
}
