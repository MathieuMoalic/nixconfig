{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../base.nix
    ../modules/sddm
    ../modules/syncthing.nix
  ];

  virtualisation = {
    # containers.cdi.nvidia = "nvidia-ctk-generate";
    libvirtd.enable = true;
    docker = {
      enable = true;
      enableNvidia = false;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    podman = {
      enable = true;
      enableNvidia = false;
      dockerCompat = false;
    };
  };
  services.caddy = {
    enable = true;
    email = "matmoa@pm.me"; # For Let's Encrypt registration
    extraConfig = ''
      joana.matmoa.xyz {
        reverse_proxy localhost:34243
      }
      cerebre.matmoa.xyz {
        reverse_proxy localhost:23848
      }
    '';
  };
  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = "80";
  };

  networking.hostName = "nyx";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80 443];
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
  system.stateVersion = "23.11";
}
