{
  config,
  lib,
  ...
}: {
  imports = [
    ./base.nix
    ./modules/syncthing.nix
  ];

  # Programs Configuration
  programs.mosh = {
    enable = true;
    openFirewall = true;
    withUtempter = true;
  };

  # Virtualization Configuration
  virtualisation = {
    containers.enable = true;
    podman.enable = true;
  };

  # Boot Configuration
  boot = {
    kernelModules = ["kvm-intel"];
    kernel = {
      sysctl = {
        "net.ipv4.ip_unprivileged_port_start" = "80";
      };
    };
    kernelParams = ["ip=dhcp"];
    initrd = {
      systemd.users.root.shell = "/bin/cryptsetup-askpass";
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 23232;
          authorizedKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmWv/s9vS1w+slUWYkRLEQWj0IBckzFHhQndHKh0qpE mat@xps"];
          hostKeys = ["/etc/secrets/initrd/ssh_host_rsa_key"];
        };
      };
      luks.devices."luks-ab805dda-b69d-48b5-9f09-5ebe3ea54918".device = "/dev/disk/by-uuid/ab805dda-b69d-48b5-9f09-5ebe3ea54918";
      luks.devices."luks-83c1b4f6-a6aa-4524-b155-84dc9c016ac6".device = "/dev/disk/by-uuid/83c1b4f6-a6aa-4524-b155-84dc9c016ac6";
      availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" "r8169"];
    };
  };

  # Networking Configuration
  networking = {
    hostName = "homeserver";
    firewall = {
      enable = true;
      # pihole: 12553
      allowedTCPPorts = [80 443 12553];
      allowedUDPPorts = [12553];
    };
    useDHCP = lib.mkDefault true;
  };

  # Services Configuration
  services = {
    openssh = {
      enable = true;
      ports = [23232];
      openFirewall = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
      };
    };
  };

  # File Systems Configuration
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/6ec0c25e-0553-4506-891e-235341dbd067";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/CDF0-18BA";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
    "/home/mat/media" = {
      device = "/dev/disk/by-uuid/5a278a0b-c553-4ace-85a0-85234d9a1541";
      fsType = "ext4";
    };
    "/home/mat/backup" = {
      device = "/dev/disk/by-uuid/4ae688c8-81d8-41a1-9585-1721b12ccfd2";
      fsType = "ext4";
    };
  };

  # Swap Devices
  swapDevices = [
    {device = "/dev/disk/by-uuid/5bc36e18-4c22-4853-9442-9f4a591de4da";}
  ];

  # Miscellaneous Configuration
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.stateVersion = "23.11";
}
