{
  lib,
  config,
  inputs,
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
    inputs.pleustradenn.nixosModules.default
  ];
  services.pleustradenn = {
    enable = true;
    databaseUrl = "sqlite:///var/lib/pleustradenn/prod.db";
    firstUserUsername = "mat";
    firstUserPassword = "matmat";
    allowRegistration = true;
    # port = 443;
    # origin = "https://example.org";
  };
  home-manager.users.mat.imports = [../home/nyx.nix];
  services.nfs.idmapd.settings = {
    General = {
      Domain = "localdomain";
      Pipefs-Directory = "/var/lib/nfs/rpc_pipefs";
    };
    Mapping = {
      Nobody-User = "nobody";
      Nobody-Group = "nogroup";
    };
    Translation = {
      Method = "nsswitch";
    };
  };
  fileSystems = {
    "/home/mat/nas" = {
      device = "150.254.111.48:/mnt/Primary/zfn/matmoa";
      fsType = "nfs";
      options = ["nfsvers=4.2"];
    };
    "/home/mat/nas2" = {
      device = "150.254.111.3:/mnt/zfn2/zfn2";
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
    kernel = {
      sysctl = {
        "net.ipv4.ip_unprivileged_port_start" = "80";
      };
    };
    kernelParams = [
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];
    # "ip=150.254.109.161::150.254.108.1:255.255.255.0:nyx::none"
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "atlantic"];
      # kernelModules = ["atlantic"];
      luks.devices."luks-813b266a-548e-4767-b73a-335378dc4693".device = "/dev/disk/by-uuid/813b266a-548e-4767-b73a-335378dc4693";

      # Decrypt the root filesystem using ssh
      systemd.users.root.shell = "/bin/cryptsetup-askpass";
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 46464;
          authorizedKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPcmHHg1pEOAxvEAyr6p5MY0m3/+BOn8nJOcAf7mMaej"
          ];
          hostKeys = ["/etc/secrets/initrd/ssh_host_rsa_key"];
        };
      };
    };
    extraModulePackages = [];
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
