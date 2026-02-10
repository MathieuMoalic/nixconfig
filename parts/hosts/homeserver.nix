{...}: {
  my.hosts.homeserver = {
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
      caddy-defaults.enable = true;
      restic.enable = true;
      scrutiny.enable = true;
      uptime.enable = true;
      immich.enable = true;
      synapse.enable = true;
      element-web.enable = true;
      authelia.enable = true;
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
    };

    home-manager.users.mat.imports = [../../home/homeserver.nix];

    boot = {
      kernelModules = ["kvm-intel"];
      kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = "80";
      kernelParams = ["ip=dhcp"];
      initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" "r8169"];
    };

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
    networking = {
      hostName = "homeserver";
      useDHCP = false;
      interfaces = {
        enp1s0 = {
          useDHCP = false;
          ipv4.addresses = [
            {
              address = "192.168.1.89";
              prefixLength = 24;
            }
          ];
        };
        wlp2s0 = {
          useDHCP = false;
          ipv4.addresses = [
            {
              address = "192.168.1.89";
              prefixLength = 24;
            }
          ];
        };
      };
      defaultGateway = "192.168.1.1";
    };

    environment.etc."NetworkManager/dispatcher.d/70-wifi-wired-exclusive.sh" = {
      mode = "0755";
      text = ''
        #!/bin/bash
        export LC_ALL=C

        enable_disable_wifi () {
          result=$(nmcli dev | grep "ethernet" | grep -w "connected")
          if [ -n "$result" ]; then
            nmcli radio wifi off
          else
            nmcli radio wifi on
          fi
        }

        if [ "$2" = "up" ] || [ "$2" = "down" ]; then
          enable_disable_wifi
        fi
      '';
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    system.stateVersion = "23.11";
  };
}
