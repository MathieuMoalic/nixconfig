{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./base.nix
    ./modules/sddm
    ./modules/syncthing.nix
    ./modules/desktop.nix
    ./modules/samba.nix
  ];
  programs.mosh = {
    enable = true;
    openFirewall = true;
    withUtempter = true;
  };

  virtualisation = {
    containers = {
      enable = true;
      cdi.dynamic.nvidia.enable = true;
    };
    podman.enable = true;
  };
  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = "80";
  };

  # This is the only way I found to set the DNS server
  environment.etc."resolv.conf".text = ''
    nameserver 109.173.160.203
    nameserver 1.1.1.1'';
  services.resolved.enable = false; # not sure if this is needed
  networking.networkmanager.dns = "none"; # not sure if this is needed

  networking = {
    hostName = "nyx";
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443];
    };
  };

  services.openssh = {
    enable = true;
    ports = [46464]; # Set SSH to listen on port 46464
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
  fileSystems."/home/mat/z1" = {
    device = "/dev/disk/by-uuid/36f3a7b3-8e76-48b8-a444-c2898aef7c29";
    fsType = "ext4";
  };
  fileSystems."/home/mat/shared" = {
    device = "/dev/disk/by-uuid/5514ec22-f46a-4542-9e1d-1dc001c68c00";
    fsType = "ext4";
  };

  boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  environment.sessionVariables = {
    # one of these might break the system
    # LIBVA_DRIVER_NAME = "nvidia";
    # XDG_SESSION_TYPE = "wayland";
    # GBM_BACKEND = "nvidia-drm"; # might crash firefox
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia"; # might break screensharing

    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    # NIXOS_OZONE_WL = "1"; # crashes vscode
  };
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  # this might crash the system
  # environment.etc."modprobe.d/nvidia.conf".text = ''
  #   options nvidia NVreg_RegistryDwords="PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3"
  # '';
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/70e39051-3e65-4be3-93d2-fafbffcd7884";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-813b266a-548e-4767-b73a-335378dc4693".device = "/dev/disk/by-uuid/813b266a-548e-4767-b73a-335378dc4693";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/65AD-6B00";
    fsType = "vfat";
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.stateVersion = "23.11";
}
