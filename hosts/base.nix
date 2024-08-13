{
  pkgs,
  modulesPath,
  lib,
  inputs,
  config,
  ...
}: {
  imports = [
    ./modules/ld.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.home-manager.nixosModules.home-manager
  ];

  # Supposedly fixes some themeing/cursor issues might be useless.
  programs.dconf.enable = true;

  environment = {
    etc."resolv.conf".text = ''
      nameserver 109.173.160.203
      nameserver 1.1.1.1'';
    binsh = "${pkgs.dash}/bin/dash";
    variables.ZDOTDIR = "$HOME/.config/zsh";
    systemPackages = with pkgs; [
      home-manager
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  nix = {
    distributedBuilds = true;
    buildMachines =
      lib.optionals (config.networking.hostName != "nyx")
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
      # for nixos
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      use-xdg-base-directories = true;
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
        "https://hyprland.cachix.org"
        "https://helix.cachix.org"
        "https://yazi.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      ];
    };
  };
  nixpkgs.config.allowUnfree = true;

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["ntfs"];
  };

  networking.networkmanager.enable = true;

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

  users = {
    groups = {
      mat = {
        gid = 1000;
      };
    };
    mutableUsers = false;
    users = {
      mat = {
        isNormalUser = true;
        group = "mat";
        linger = true;
        uid = 1000;
        extraGroups = ["networkmanager" "wheel" "video" "input" "uinput"];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGXS+yVAISHyMWzk+o/jHHMnt9aILZoOFPqe/EkhoDIj"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJH2ihm6q8TDs3UlY7yQqkfzze/l2S4cVlNGLvSpZh6G"
        ];
        hashedPassword = "$6$4lSS.DgMsihs04VX$uu3991ckntJRdsu/Mo7nYuo06M7s9zXDRT7l110LUjPN4lq1OtUNC1ER/WEaLXCSNBxIiZfMWKc0jdBN.xRs1.";
        shell = pkgs.zsh;
      };
      root = {
        hashedPassword = "$6$4lSS.DgMsihs04VX$uu3991ckntJRdsu/Mo7nYuo06M7s9zXDRT7l110LUjPN4lq1OtUNC1ER/WEaLXCSNBxIiZfMWKc0jdBN.xRs1.";
      };
    };
  };

  programs.zsh.enable = true;

  home-manager = {
    backupFileExtension = "bak";
    extraSpecialArgs = {inherit inputs;};
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
