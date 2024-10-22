{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./base.nix
    ./modules/sddm/sddm.nix
    ./modules/syncthing.nix
    ./modules/desktop.nix
  ];
  programs.steam.enable = true;
  programs.ssh.startAgent = true;
  home-manager.users.mat.imports = [../home/xps.nix];
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    brillo.enable = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  networking = {
    wireless.userControlled.enable = true;
    useDHCP = lib.mkDefault true;
    hostName = "xps";
  };
  powerManagement = {
    powertop.enable = true;
    cpuFreqGovernor = lib.mkDefault "powersave";
  };

  services = {
    blueman.enable = true;
    # for brillo (1st line)
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
      KERNEL=="uinput", GROUP="input", TAG+="uaccess"
    '';
  };

  boot = {
    initrd = {
      secrets = {"/crypto_keyfile.bin" = null;};
      luks.devices = {
        "luks-697ee5de-1a53-475e-9285-19fbc72bc068".device = "/dev/disk/by-uuid/697ee5de-1a53-475e-9285-19fbc72bc068";
        "luks-697ee5de-1a53-475e-9285-19fbc72bc068".keyFile = "/crypto_keyfile.bin";
        "luks-63890607-1aa3-4a8d-a666-6e0200eda2b4".device = "/dev/disk/by-uuid/63890607-1aa3-4a8d-a666-6e0200eda2b4";
      };
      availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/fd49111d-571b-4f77-be35-d694f0e9f217";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/724A-1C0C";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/b280acec-cb05-4502-83cd-fd5dc35f7ed6";}
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "23.05";
}
