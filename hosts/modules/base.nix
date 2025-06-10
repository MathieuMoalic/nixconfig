{
  pkgs,
  modulesPath,
  lib,
  inputs,
  config,
  ...
}: {
  # This file is the base configuration for all hosts.
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.home-manager.nixosModules.home-manager
    inputs.homepage.nixosModules.homepage-service
    inputs.pleustradenn.nixosModules.pleustradenn-service
    inputs.boued.nixosModules.pleustradenn-service
    inputs.sops-nix.nixosModules.sops
    inputs.disko.nixosModules.disko
    ./users/mat.nix
  ];
  # this fixes the dns in rootless podman containers
  environment.etc."resolv.conf".mode = "direct-symlink";

  sops = {
    defaultSopsFile = ../../secrets.yaml;
    age.keyFile = "/home/mat/.ssh/age_key";
  };
  programs.fish.enable = true;

  programs.nix-ld = {
    enable = true;
  };

  security.sudo-rs = {
    enable = true;
    wheelNeedsPassword = false;
    execWheelOnly = true;
  };

  services = {
    earlyoom = {
      enable = true;
      extraArgs = ["-g" "--prefer" "(^|/)(python)$"];
      enableNotifications = true;
    };
    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };
    resolved = {
      enable = true;
      fallbackDns = ["9.9.9.9" "149.112.112.112"];
      domains = ["~."];
      dnsovertls = "true";
      dnssec = "true";
    };
  };
  hardware.keyboard.qmk.enable = true;

  # remove the need to type in the password for sudo
  security.sudo.wheelNeedsPassword = false;

  # Supposedly fixes some themeing/cursor issues might be useless.
  programs.dconf.enable = true;
  networking = {
    networkmanager.enable = true;
    networkmanager.dns = "systemd-resolved";

    nameservers = ["9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net"];
    enableIPv6 = true;
  };
  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    systemPackages = with pkgs; [
      home-manager
      rose-pine-hyprcursor
    ];
  };

  nix = {
    distributedBuilds = true;
    buildMachines =
      lib.optionals (!(config.networking.hostName == "nyx" || config.networking.hostName == "zagreus"))
      [
        {
          hostName = "nyx";
          systems = ["x86_64-linux" "aarch64-linux"];
          maxJobs = 30;
          speedFactor = 10;
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          sshKey = "/home/mat/.ssh/id_ed25519";
          sshUser = "mat";
        }
      ];
    channel.enable = false;
    package = pkgs.nix;
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      experimental-features = "nix-command flakes";
      # auto-optimise-store = true; # This makes nixos-rebuild slower
      use-xdg-base-directories = true;
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    # Purge Unused Nix-Store Entries
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
  # this is to silence the warning when using the `nixos-rebuild` command
  # systemd.services."systemd-hibernate-clear".enable = false;

  boot = {
    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 15;
      };
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["ntfs"];
    initrd.systemd.enable = true; # Needed for hibernation
  };

  time.timeZone = lib.mkDefault "Europe/Warsaw";

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
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
  };

  programs.zsh.enable = true;

  home-manager = {
    backupFileExtension = "hmbak";
    extraSpecialArgs = {inherit inputs;};
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
