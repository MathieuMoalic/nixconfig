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
    ./modules/self-hosted/wireguard.nix
    ./modules/self-hosted/stirling-pdf.nix
    ./modules/self-hosted/ntfy.nix
    ./modules/self-hosted/vaultwarden.nix
    # ./modules/self-hosted/your-spotify.nix
  ];

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
      systemd.users.root.shell = "/bin/cryptsetup-askpass";
      # systemd.initrdBin = with pkgs; [cryptsetup];
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 46466;
          authorizedKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPcmHHg1pEOAxvEAyr6p5MY0m3/+BOn8nJOcAf7mMaej"
          ];
          hostKeys = ["/etc/secrets/initrd/ssh_host_rsa_key"];
        };
      };
      luks.devices."luks-ab805dda-b69d-48b5-9f09-5ebe3ea54918".device = "/dev/disk/by-uuid/ab805dda-b69d-48b5-9f09-5ebe3ea54918";
      luks.devices."luks-83c1b4f6-a6aa-4524-b155-84dc9c016ac6".device = "/dev/disk/by-uuid/83c1b4f6-a6aa-4524-b155-84dc9c016ac6";
      availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" "r8169"];
    };
  };

  networking = {
    hostName = "homeserver";
    firewall = {
      enable = true;
      # pihole: 12553
      # wireguard: 51820
      # jellyfin: 10024
      # coturn: 3478 5349 49160-49200/udp
      allowedTCPPorts = [80 443 12553 10024 3478 5349];
      allowedUDPPorts = [12553 51820 7359 3478 5349] ++ (map (x: x) (builtins.genList (x: 49160 + x) (49200 - 49160 + 1)));
    };
    useDHCP = lib.mkDefault true;
  };

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

  swapDevices = [
    {device = "/dev/disk/by-uuid/5bc36e18-4c22-4853-9442-9f4a591de4da";}
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.stateVersion = "23.11";
}
