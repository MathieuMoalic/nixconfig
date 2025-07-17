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
    ./modules/podman.nix
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
    "/home/mat/z2/double_freq_gen/nas" = {
      device = "150.254.111.3:/mnt/zfn2/zfn2/matmoa/jobs/double_freq_gen";
      fsType = "nfs";
      options = ["nfsvers=4.2"];
    };
    "/home/mat/z1/preludium/nas" = {
      device = "150.254.111.3:/mnt/zfn2/zfn2/matmoa/jobs/preludium";
      fsType = "nfs";
      options = ["nfsvers=4.2"];
    };
    "/home/mat/z1/mannga/nas" = {
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
    "/home/mat/z1" = {
      device = "/dev/disk/by-label/z1";
      fsType = "ext4";
    };
    "/home/mat/z2" = {
      device = "/dev/disk/by-label/shared";
      fsType = "ext4";
    };
  };

  hardware = {
    nvidia-container-toolkit.enable = true;
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
    kernelModules = ["kvm-amd" "debug"];
    kernel.sysctl = {"net.ipv4.ip_unprivileged_port_start" = "80";};
    kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];

    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "atlantic"];
      luks.devices."luks-813b266a-548e-4767-b73a-335378dc4693".device = "/dev/disk/by-uuid/813b266a-548e-4767-b73a-335378dc4693";

      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 46464;
          ignoreEmptyHostKeys = true;
          authorizedKeys =
            lib.mkDefault
            config.users.users.mat.openssh.authorizedKeys.keys;
          hostKeys = ["/etc/secrets/initrd/ssh_host_rsa_key"];
        };
      };
      systemd = {
        enable = true;
        network = {
          enable = true;
          networks."20-enp4s0" = {
            matchConfig.Name = "enp4s0"; # your Aquantia card
            networkConfig = {
              Address = "150.254.109.161/22";
              Gateway = "150.254.108.1";
              DNS = "9.9.9.9";
            };
          };
        };
      };
    };
  };

  networking = {
    hostName = "nyx";
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443];
    };
    useDHCP = lib.mkDefault true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "23.11";
}
