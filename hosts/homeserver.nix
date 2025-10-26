{
  config,
  lib,
  ...
}: {
  imports = [
    ./modules/base.nix
    ./modules/syncthing.nix
    ./modules/sshd.nix
    ./modules/restic.nix
    ./modules/podman.nix
    ./modules/self-hosted/caddy.nix
    ./modules/self-hosted/authelia.nix
    ./modules/self-hosted/pleustradenn.nix
    ./modules/self-hosted/homepage.nix
    ./modules/self-hosted/boued.nix
    ./modules/self-hosted/stirling-pdf.nix
    ./modules/self-hosted/ntfy.nix
    ./modules/self-hosted/vaultwarden.nix
    ./modules/self-hosted/libretranslate.nix
    ./modules/self-hosted/owntracks.nix
  ];
  services = {
    mosquitto = {
      enable = true;
    };
    flaresolverr.port = 8191;
    flaresolverr.enable = true;
  };

  myModules = {
    audiobookshelf.enable = true;
    jellyfin.enable = true;
    jellyseerr.enable = true;
    prowlarr.enable = true;
    sonarr.enable = true;
    radarr.enable = true;
    bazarr.enable = true;
    transmission.enable = true;
    watcharr.enable = true;
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

  networking = {
    hostName = "homeserver";
    firewall = {
      enable = true;
      # wireguard: 51820
      # jellyfin: 10024
      # coturn: 3478 5349 49160-49200/udp
      allowedTCPPorts = [80 443 10024 3478 5349];
      allowedUDPPorts = [51820 7359 3478 5349] ++ (map (x: x) (builtins.genList (x: 49160 + x) (49200 - 49160 + 1)));
    };
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
    "/home/mat/media" = {
      device = "/dev/disk/by-uuid/5a278a0b-c553-4ace-85a0-85234d9a1541";
      fsType = "ext4";
    };
    "/media" = {
      device = "/dev/disk/by-uuid/5a278a0b-c553-4ace-85a0-85234d9a1541";
      fsType = "ext4";
    };
    "/home/mat/backup" = {
      device = "/dev/disk/by-uuid/4ae688c8-81d8-41a1-9585-1721b12ccfd2";
      fsType = "ext4";
    };
  };
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.stateVersion = "23.11";
}
