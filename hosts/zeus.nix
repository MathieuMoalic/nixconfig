{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./base.nix
    ./modules/sddm.nix
    ./modules/desktop.nix
  ];
  users.groups = {
    mz = {
      gid = 1001;
    };
  };
  users.users.mz = {
    isNormalUser = true;
    uid = 1001;
    description = "mz";
    group = "mz";
    extraGroups = [];
    shell = pkgs.zsh;
  };

  programs.mosh = {
    enable = true;
    openFirewall = true;
    withUtempter = true;
  };

  hardware.nvidia-container-toolkit.enable = true;
  virtualisation = {
    containers.enable = true;
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
    hostName = "zeus";
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443];
    };
  };

  services.openssh = {
    enable = true;
    ports = [46464];
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
  hardware.opengl.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/39595a30-eacd-4724-ba4a-ffd9faf23ba3";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/339D-CFC9";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/db46381c-7ffd-4080-91e3-94a2bf27c6ac";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.stateVersion = "23.11";
}
