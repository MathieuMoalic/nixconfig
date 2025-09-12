{
  lib,
  config,
  ...
}: {
  imports = [
    ./modules/base.nix
    ./modules/sddm/sddm.nix
    ./modules/sshd.nix
    ./modules/podman.nix
    ./modules/sudo-rules.nix
    ./modules/users/mz.nix
  ];
  home-manager.users.mat.imports = [../home/alecto.nix];

  services.caddy = {
    enable = true;
    configFile = "/mateusz_change_this_caddyfile";
  };

  virtualisation.oci-containers.containers.wg-easy = {
    autoStart = true;
    image = "ghcr.io/wg-easy/wg-easy:14";
    environment = {
      WG_HOST = "vpn2.zfns.eu.org";
      PASSWORD = "your-password"; # Admin password for WG-Easy
    };
    ports = ["51820:51820/udp" "51821:51821/tcp"];
    volumes = [
      "/home/mat/wg-easy:/etc/wireguard:z"
    ];
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--cap-add=SYS_MODULE"
      "--cap-add=NET_RAW"
      "--sysctl=net.ipv4.conf.all.src_valid_mark=1"
      "--sysctl=net.ipv4.ip_forward=1"
    ];
  };

  hardware = {
    graphics.enable = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  boot = {
    kernel.sysctl = {
      "net.ipv4.ip_unprivileged_port_start" = "80";
    };
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = [];
    };
    kernelModules = ["kvm-amd" "debug" "wireguard"];
    extraModulePackages = [];
  };

  networking = {
    hostName = "alecto";
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443 51821]; # WG-Easy Web UI
      allowedUDPPorts = [51820]; # WireGuard port
    };
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

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

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "23.11";
}
