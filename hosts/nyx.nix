{lib, ...}: {
  myModules = {
    desktop.enable = true;
    kmonad.enable = true;
    base.enable = true;
    sshd.enable = true;
    nfs.enable = true;
    syncthing.enable = true;
  };
  home-manager.users.mat.imports = [../home/nyx.nix];
  hardware.keyboard.qmk.enable = true;
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
  };

  services.xserver.videoDrivers = ["nvidia"];
  hardware = {
    graphics.enable = true;
    nvidia.open = false;
    cpu.amd.updateMicrocode = true;
  };
  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "atlantic"];
      luks.devices."luks-813b266a-548e-4767-b73a-335378dc4693".device = "/dev/disk/by-uuid/813b266a-548e-4767-b73a-335378dc4693";
    };
  };

  networking = {
    hostName = "nyx";
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "23.11";
}
