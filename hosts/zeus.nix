{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/base.nix
    ./modules/sddm/sddm.nix
    ./modules/sshd.nix
    ./modules/podman.nix
    ./modules/sudo-rules.nix
    ./modules/users/mz.nix
    ./modules/users/kelvas.nix
    ./modules/users/syam.nix
  ];
  home-manager.users.mat.imports = [../home/zeus.nix];

  environment.systemPackages = with pkgs; [
    amumax
    nvtopPackages.nvidia
  ];

  hardware = {
    nvidia-container-toolkit.enable = true;
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  boot = {
    kernel.sysctl = {
      "net.ipv4.ip_unprivileged_port_start" = "80";
    };
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  networking = {
    hostName = "zeus";
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443];
    };
    useDHCP = lib.mkDefault true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/39595a30-eacd-4724-ba4a-ffd9faf23ba3";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/339D-CFC9";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/db46381c-7ffd-4080-91e3-94a2bf27c6ac";}
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "23.11";
}
