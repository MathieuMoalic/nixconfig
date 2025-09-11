{
  lib,
  config,
  ...
}: {
  imports = [
    ./modules/base.nix
    ./modules/desktop.nix
    ./modules/sddm/sddm.nix
    ./modules/syncthing.nix
    ./modules/sshd.nix
    ./modules/kmonad.nix
  ];
  home-manager.users.mat.imports = [../home/nyx.nix];

  fileSystems = {
    "/home/mat/nas" = {
      device = "150.254.111.48:/mnt/Primary/zfn/matmoa";
      fsType = "nfs";
      options = ["nfsvers=4.2"];
    };
    "/home/mat/nas2/matmoa" = {
      device = "150.254.111.3:/mnt/zfn2/zfn2/matmoa";
      fsType = "nfs";
      options = ["nfsvers=4.2"];
    };
    "/home/mat/projects/double_freq_gen/nas" = {
      device = "150.254.111.3:/mnt/zfn2/zfn2/matmoa/jobs/double_freq_gen";
      fsType = "nfs";
      options = ["nfsvers=4.2"];
    };
    "/home/mat/projects/preludium/nas" = {
      device = "150.254.111.3:/mnt/zfn2/zfn2/matmoa/jobs/preludium";
      fsType = "nfs";
      options = ["nfsvers=4.2"];
    };
    "/home/mat/projects/mannga/nas" = {
      device = "150.254.111.3:/mnt/zfn2/zfn2/matmoa/jobs/mannga";
      fsType = "nfs";
      options = ["nfsvers=4.2"];
    };
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
    nvidia = {
      modesetting.enable = true; # Needed for Hyprland
      powerManagement = {
        enable = true;
        finegrained = false;
      };
      nvidiaSettings = true;
      open = false;
    };
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
  boot = {
    # kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];

    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "atlantic"];
      luks.devices."luks-813b266a-548e-4767-b73a-335378dc4693".device = "/dev/disk/by-uuid/813b266a-548e-4767-b73a-335378dc4693";
    };
  };

  networking = {
    hostName = "nyx";
    useDHCP = lib.mkDefault true;
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
