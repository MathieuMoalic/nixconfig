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
    inputs.boued.nixosModules.boued-service
    inputs.sops-nix.nixosModules.sops
    inputs.disko.nixosModules.disko
    ./users/mat.nix
  ];
  environment = {
    # this fixes the dns in rootless podman containers
    etc."resolv.conf".mode = "direct-symlink";

    binsh = "${pkgs.dash}/bin/dash";
    systemPackages = with pkgs; [
      home-manager
      rose-pine-hyprcursor
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
  # };
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    age.keyFile = "/home/mat/.ssh/age_key";
  };
  programs = {
    fish.enable = true;

    nix-ld = {
      enable = true;
    };

    # Supposedly fixes some themeing/cursor issues might be useless.
    dconf.enable = true;

    zsh.enable = true;
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

  boot = {
    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
        editor = true;
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

  home-manager = {
    backupFileExtension = "hmbak";
    extraSpecialArgs = {inherit inputs;};
    useUserPackages = true;
    useGlobalPkgs = true;
  };
}
