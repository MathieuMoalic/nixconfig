{
  lib,
  config,
  ...
}: {
  imports = [
    ./base.nix
    ./modules/desktop.nix
    ./modules/sddm.nix
    ./modules/syncthing.nix
    ./modules/samba.nix
  ];
  home-manager.users.mat.imports = [../home/nyx.nix];

  programs.mosh = {
    enable = true;
    openFirewall = true;
    withUtempter = true;
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
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  virtualisation = {
    containers.enable = true;
    podman.enable = true;
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
            # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmWv/s9vS1w+slUWYkRLEQWj0IBckzFHhQndHKh0qpE mat@xps"
            # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKvwnSlOK1csvW9qzPS8nGzq8DMlu4+/QebcEjDZDK04 oneplus"
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
      allowedTCPPorts = [80 443 35367];
    };
    useDHCP = lib.mkDefault true;
  };

  services = {
    openssh = {
      enable = true;
      ports = [46464];
      openFirewall = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
      };
    };
    xserver.videoDrivers = ["nvidia"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/70e39051-3e65-4be3-93d2-fafbffcd7884";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/65AD-6B00";
      fsType = "vfat";
    };
    "/home/mat/z1" = {
      device = "/dev/disk/by-uuid/36f3a7b3-8e76-48b8-a444-c2898aef7c29";
      fsType = "ext4";
    };
    "/home/mat/shared" = {
      device = "/dev/disk/by-uuid/5514ec22-f46a-4542-9e1d-1dc001c68c00";
      fsType = "ext4";
    };
  };

  swapDevices = [];

  environment.sessionVariables = {
    # WLR_NO_HARDWARE_CURSORS = "1";
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "23.11";
}
