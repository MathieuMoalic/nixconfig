{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./modules/base.nix
    ./modules/sddm/sddm.nix
    ./modules/desktop.nix
    ./modules/syncthing.nix
    ./modules/kmonad.nix
    ./modules/podman.nix
  ];
  hardware.wooting.enable = true;
  programs.steam = {
    enable = true;
  };
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
      };

      # Warning: GPU optimisations have the potential to damage hardware
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };

      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };
  home-manager.users.mat.imports = [../home/zagreus.nix];
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "zagreus";
    firewall.allowedTCPPorts = [4173 5173];
  };

  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = [];
      systemd.enable = true;
    };
    kernelModules = [];
    kernelPackages = pkgs.linuxPackages_testing;
    extraModprobeConfig = ''
      options iwlwifi power_save=0 uapsd_disable=1 enable_ini=0
      options iwlmvm power_scheme=1
    '';
    kernelParams = ["pcie_aspm=off"]; # Keeps all PCIe links in the fully active state.
    extraModulePackages = [];
  };
  environment.etc."NetworkManager/conf.d/99-wifi-powersave.conf".text = ''
    [connection]
    wifi.powersave=2
  '';

  # Optional but often smoother with Intel:
  # networking.networkmanager.enable = true;
  # networking.networkmanager.wifi.backend = "iwd";
  services = {
    sunshine = {
      enable = true;
      openFirewall = true;
      autoStart = true;
      capSysAdmin = true;
    };
    udev.extraRules = ''
      ACTION=="add" SUBSYSTEM=="pci" ATTR{vendor}=="0x1987" ATTR{device}=="0x5013" ATTR{power/wakeup}="disabled"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="31e3", ATTR{idProduct}=="1312", ATTR{power/wakeup}="disabled"
    '';
    # iwd.enable = true;
  };

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
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024;
    }
  ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "24.05";
}
