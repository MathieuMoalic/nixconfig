{
  config,
  lib,
  ...
}: {
  myModules = {
    base.enable = true;
    users.cerebre = true;
    podman.enable = true;
    sshd.enable = true;
    syncthing.enable = true;
    nfs.nas = true;
    nfs.nas2 = true;
    caddy-defaults.enable = true;
    restic.enable = true;
    scrutiny.enable = true;
    uptime.enable = true;
    immich.enable = true;
    synapse.enable = true;
    element-web.enable = true;
    authelia.enable = true;
    boued.enable = true;
    homepage.enable = true;
    ntfy.enable = true;
    libretranslate.enable = true;
    pleustradenn.enable = true;
    stirling-pdf.enable = true;
    vaultwarden.enable = true;
    audiobookshelf.enable = true;
    jellyfin.enable = true;
    jellyseerr.enable = true;
    prowlarr.enable = true;
    sonarr.enable = true;
    radarr.enable = true;
    bazarr.enable = true;
    flaresolverr.enable = true;
    transmission.enable = true;
    watcharr.enable = true;
    blaz.enable = true;
    # wireguard = {
    #   enable = true;
    #   peers = [
    #     {
    #       name = "nyx";
    #       publicKey = "e+IOBLCdy3F1KK51mOI1UBbTgfldEKkNZvk8MLUY9gk=";
    #       allowedIPs = ["10.8.0.2/32"];
    #     }
    #   ];
    # };
    # bar.enable = true;
  };

  home-manager.users.mat.imports = [../home/homeserver.nix];

  boot = {
    kernelModules = ["kvm-intel"];
    kernel = {
      sysctl = {
        "net.ipv4.ip_unprivileged_port_start" = "80";
      };
    };
    kernelParams = ["ip=dhcp"];
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" "r8169"];
    };
  };

  # Make the working and final dirs NOCOW (+C). This affects new files created there.
  systemd.tmpfiles.rules = [
    "d /media 0755 mat media -"
    "h /media - - - - +C"
  ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = ["/media"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/1ca3b588-bdcd-40ca-baaa-806103f631c0";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/CDF0-18BA";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
    "/media" = {
      device = "/dev/disk/by-label/media";
      fsType = "btrfs";
      options = ["noatime"];
    };
    "/mnt/ehdd" = {
      device = "/dev/disk/by-uuid/4ae688c8-81d8-41a1-9585-1721b12ccfd2";
      fsType = "ext4";
    };
  };
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
    }
  ];

  networking.hostName = "homeserver";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.stateVersion = "23.11";
}
