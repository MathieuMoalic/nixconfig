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

  programs.mosh = {
    enable = true;
    openFirewall = true;
    withUtempter = true;
  };

  virtualisation = {
    containers = {
      enable = true;
    };
    podman.enable = true;
  };
  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = "80";
  };

  services.localtimed.enable = true;
  # This is the only way I found to set the DNS server
  environment.etc."resolv.conf".text = ''
    nameserver 1.1.1.1'';
  services.resolved.enable = false; # not sure if this is needed
  networking.networkmanager.dns = "none"; # not sure if this is needed

  networking = {
    hostName = "homeserver";
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443 12553];
      allowedUDPPorts = [12553];
    };
  };

  services.openssh = {
    enable = true;
    ports = [23232]; # Set SSH to listen on port 46464
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  boot.kernelParams = ["ip=dhcp"];
  boot.initrd = {
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
  };

  boot.initrd.luks.devices."luks-ab805dda-b69d-48b5-9f09-5ebe3ea54918".device = "/dev/disk/by-uuid/ab805dda-b69d-48b5-9f09-5ebe3ea54918";
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" "r8169"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/6ec0c25e-0553-4506-891e-235341dbd067";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-83c1b4f6-a6aa-4524-b155-84dc9c016ac6".device = "/dev/disk/by-uuid/83c1b4f6-a6aa-4524-b155-84dc9c016ac6";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CDF0-18BA";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/5bc36e18-4c22-4853-9442-9f4a591de4da";}
  ];

  fileSystems."/home/mat/media" = {
    device = "/dev/sda1";
    fsType = "ext4"; # Replace with your filesystem type (e.g., "vfat", "ntfs")
    options = ["defaults"]; # Additional mount options can be added here
  };
  fileSystems."/home/mat/backup" = {
    device = "/dev/sdc1";
    fsType = "ext4"; # Replace with your filesystem type (e.g., "vfat", "ntfs")
    options = ["defaults"]; # Additional mount options can be added here
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.stateVersion = "23.11";
}
