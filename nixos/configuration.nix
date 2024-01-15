{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./sddm
  ];

  # services.jupyter = {
  #   enable = true;
  #   password = "'argon2:$argon2id$v=19$m=10240,t=10,p=8$kG/+hvcrvaGNV04E1mTK9w$SGbVNx0gHQjIpyUdIq6gZBSapQQTbnzrZAuifMl5FUw'";
  #   user = "mat";
  #   group = "users";
  #   kernels = {
  #     python3 = let
  #       pyzfn = pkgs.python3.pkgs.buildPythonPackage rec {
  #         pname = "pyzfn";
  #         version = "0.1.9"; # Replace with the correct version

  #         src = pkgs.python3.pkgs.fetchPypi {
  #           inherit pname version;
  #           sha256 = "dYEan70hLl6HUEFowDgxIbcJYcUcFPxV2TxqeD7/kz8="; # Replace with the correct sha256 hash
  #         };
  #         doCheck = false; # Disable tests if not required or if they don't pass
  #       };
  #       peakutils = pkgs.python3.pkgs.buildPythonPackage rec {
  #         pname = "PeakUtils";
  #         version = "1.3.4";
  #         src = pkgs.python3.pkgs.fetchPypi {
  #           inherit pname version;
  #           sha256 = "iSBCajlCTqnwJc12oMGRUBBxQ2cL6kfkk11ENfZeY3A=";
  #         };
  #         doCheck = false; # Disable tests if not required or if they don't pass
  #       };
  #       cmocean = pkgs.python3.pkgs.buildPythonPackage rec {
  #         pname = "cmocean";
  #         version = "3.0.3";
  #         src = pkgs.python3.pkgs.fetchPypi {
  #           inherit pname version;
  #           sha256 = "q6+ZODwaYPUpcMhgUq5sFOr6hPwWmESIBAKDwC23fAs=";
  #         };
  #         doCheck = false; # Disable tests if not required or if they don't pass
  #       };

  #       pythonEnv = pkgs.python3.withPackages (pythonPackages:
  #         with pythonPackages; [
  #           peakutils
  #           cmocean
  #           ipykernel
  #           matplotlib
  #           scipy
  #           dill
  #           pyzfn
  #         ]);
  #     in {
  #       displayName = "Python 3 (Nyx)";
  #       argv = [
  #         "${pythonEnv.interpreter}"
  #         "-m"
  #         "ipykernel_launcher"
  #         "-f"
  #         "{connection_file}"
  #       ];
  #       language = "python";
  #       extraPaths = {
  #       };
  #     };
  #   };
  # };
  # To mount windows drives
  boot.supportedFilesystems = ["ntfs"];

  fonts.packages = with pkgs; [
    corefonts
    proggyfonts
  ];
  security.sudo.wheelNeedsPassword = false;
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
  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
      enableNvidia = true;
    };
    podman = {
      enable = true;
      enableNvidia = true;
      dockerCompat = false;
    };
  };
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  # virtualisation.podman = {
  #   enable = true;
  #   dockerSocket.enable = false;
  #   dockerCompat = false; # alias docker to podman
  #   autoPrune.enable = true; # weekly by default
  #   enableNvidia = true;
  # };
  # virtualisation.docker = {
  #   enable = true;
  #   enableNvidia = true;
  # };
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

  # # Make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
  # environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";

  # This is to allow wireguard through the firewall
  networking.firewall = {
    # if packets are still dropped, they will show up in dmesg
    logReversePathDrops = true;
    # wireguard trips rpfilter up
    extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
    '';
    extraStopCommands = ''
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
    '';
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
    channel.enable = true; # disable nix-channel, we use flakes instead.
    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath =
      lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;
    package = pkgs.nix;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      use-xdg-base-directories = true;
      # substituters = [ "https://hyprland.cachix.org" ];
      # trusted-public-keys = [
      #   "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      # ];
    };
  };

  # for brillo (1st line) and xremap (2nd line)
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
    KERNEL=="uinput", GROUP="input", TAG+="uaccess"
  '';
  hardware.brillo.enable = true;
  hardware.uinput.enable = true; # for xremap

  environment.binsh = "${pkgs.dash}/bin/dash";
  programs.hyprland.enable = true;

  # services.xserver = {
  #   layout = "us";
  #   xkbVariant = "";
  #   enable = true;
  #   displayManager.sddm.enable = true;
  #   displayManager.sddm.theme = "Dracula";
  # };
  programs.hyprland.xwayland = {enable = true;};

  security.pam.services.swaylock = {}; # needed for swaylock

  # rtkit is optional but recommended
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # security.polkit.enable = true;
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    extraConfig = "DefaultTimeoutStopSec=10s";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  # boot.initrd.secrets = {"/crypto_keyfile.bin" = null;};

  # Enable swap on luks
  # boot.initrd.luks.devices."luks-697ee5de-1a53-475e-9285-19fbc72bc068".device = "/dev/disk/by-uuid/697ee5de-1a53-475e-9285-19fbc72bc068";
  # boot.initrd.luks.devices."luks-697ee5de-1a53-475e-9285-19fbc72bc068".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "xps";
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  users.groups = {
    mat = {
      gid = 1000;
    };
  };
  users.users.mat = {
    isNormalUser = true;
    description = "mat";
    group = "mat";
    extraGroups = ["networkmanager" "wheel" "video" "input" "uinput"];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
  environment.variables = {ZDOTDIR = "/home/mat/.config/zsh";};

  environment.systemPackages = with pkgs; [
    home-manager
    nvidia-podman
    hyprland
  ];

  system.stateVersion = "23.05";
}
