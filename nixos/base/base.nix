{
  flake.nixosModules.base = {
    self,
    pkgs,
    lib,
    inputs,
    config,
    ...
  }: {
    imports = with self.nixosModules; [
      syncthing
      dns
    ];

    nixpkgs.config.allowUnfree = true;
    hardware.enableRedistributableFirmware = true;

    environment = {
      binsh = "${pkgs.dash}/bin/dash";
    };
    sops = {
      defaultSopsFile = self + "/secrets.yaml";
      age.keyFile = "/home/mat/.ssh/age_key";
    };
    programs = {
      fish.enable = true;
      nix-ld.enable = true;
    };

    security = {
      sudo-rs = {
        enable = true;
        wheelNeedsPassword = false;
        execWheelOnly = true;
      };
      polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          var allowed = [
            "org.freedesktop.login1.reboot",
            "org.freedesktop.login1.reboot-multiple-sessions",
            "org.freedesktop.login1.power-off",
            "org.freedesktop.login1.power-off-multiple-sessions",
            "org.freedesktop.login1.halt",
            "org.freedesktop.login1.halt-multiple-sessions"
          ];

          if (allowed.indexOf(action.id) >= 0 &&
              subject.active &&
              subject.isInGroup("wheel")) {
            return polkit.Result.YES;
          }
        });
      '';
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

    environment.pathsToLink = [
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];

    nix = {
      channel.enable = false;
      package = pkgs.nix;
      settings = {
        trusted-users = [
          "root"
          "@wheel"
        ];
        experimental-features = "nix-command flakes";
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
        timeout = 3;
        systemd-boot = {
          enable = true;
          editor = true;
          configurationLimit = 50;
        };
        efi.canTouchEfiVariables = true;
      };
      supportedFilesystems = ["ntfs" "btrfs"];
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
      extraSpecialArgs = {inherit inputs self;};
      useUserPackages = true;
      useGlobalPkgs = true;
    };
  };
}
