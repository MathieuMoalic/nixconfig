{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/base.nix
    ./modules/sddm/sddm.nix
    ./modules/sshd.nix
    ./modules/wireguard.nix
  ];
  home-manager.users.mat.imports = [../home/alecto.nix];

  security.sudo.extraRules = [
    {
      groups = ["users"];
      commands = [
        {
          command = "/run/wrappers/bin/mount";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/wrappers/bin/umount";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/wrappers/bin/reboot";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  users.users.mz = {
    isNormalUser = true;
    uid = 1001;
    initialPassword = "nixos";
    shell = pkgs.zsh;
    extraGroups = ["networkmanager" "wheel" "video" "input" "uinput"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKJT9ZTSPiYwsVoaSBRTZ6WLVn1wt5FTIwwO6BEcusXa mateusz@DESKTOP-LC7F3KD"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPcmHHg1pEOAxvEAyr6p5MY0m3/+BOn8nJOcAf7mMaej"
    ];
  };

  hardware = {
    graphics.enable = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  virtualisation = {
    containers.enable = true;
    podman.enable = true;
  };

  boot = {
    kernel.sysctl = {
      "net.ipv4.ip_unprivileged_port_start" = "80";
    };
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = [];
    };
    kernelModules = ["kvm-amd" "debug"];
    extraModulePackages = [];
  };

  networking = {
    hostName = "alecto";
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443];
    };
    useDHCP = lib.mkDefault true;
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
