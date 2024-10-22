{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./base.nix
    ./modules/sddm/sddm.nix
    ./modules/sshd.nix
  ];
  home-manager.users.mat.imports = [../home/zeus.nix];

  environment.systemPackages = with pkgs; [
    inputs.amumax.packages.${pkgs.system}.git
    nvtopPackages.nvidia
  ];

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
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys =
      [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKJT9ZTSPiYwsVoaSBRTZ6WLVn1wt5FTIwwO6BEcusXa mateusz@DESKTOP-LC7F3KD"
      ]
      ++ config.users.users.mat.openssh.authorizedKeys.keys;
  };

  users.users.kelvas = {
    isNormalUser = true;
    uid = 1002;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys =
      [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDNNLMQFqQvcw2/OyVIsKTxi8WUqcBKFIcYGwZZYM3DT2wQ3uJ1Z2u5KGoJI9DEaf8nZPsIsQnYHNAwYqeMbxdgenLgbtJmS2Afxzv7wD/3w/Ydn2HTTLMmm7gUbJ7RT3NWo5nYHhBTXiPmuYCGJ5TggbXuZhT3kN4Gy5czItpIQlDHUzVrgYbvkUQEhxB+rt5bgwAtk2V8QGFaOo7qkXK3hlq/Ff3SLRvtXQo3v3wEUr7ULO/xkzp5go+Tn5iM0ZyTyzOyBqHmqZKeuCc3P087WuUNn7WH0qTwbQUrHS7anXv5AB23J/bf3A7OSmLx9oEyJQ42r5KRfG/SITjKo5VtrOMMn6sADjF2B7vbGBWisQVbIRdvtEdRhpPGfs7Cz0QCphjNlGCGdghSY2e51p/IUoWWUIA+m6AtACFXr2ZOSBzi4OL5GXpmFpV/dgY6T01CXKPfrkML6vGnw8kwLk7ERng6nn3Gpl1yOi+Bt07qzXu8OKJDP0EFv+BW/wMIFcU="
      ]
      ++ config.users.users.mat.openssh.authorizedKeys.keys;
  };

  users.users.syam = {
    isNormalUser = true;
    uid = 1003;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys =
      [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3nskcuXUBuIikiFZ1MT8L+srlSVJnARaLTNdfAGbmZ syam@megaera"
      ]
      ++ config.users.users.mat.openssh.authorizedKeys.keys;
  };

  hardware = {
    nvidia-container-toolkit.enable = true;
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
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
      availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  networking = {
    hostName = "zeus";
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443];
    };
    useDHCP = lib.mkDefault true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/39595a30-eacd-4724-ba4a-ffd9faf23ba3";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/339D-CFC9";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/db46381c-7ffd-4080-91e3-94a2bf27c6ac";}
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "23.11";
}
