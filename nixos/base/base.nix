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
      age.sshKeyPaths = [
        "/home/mat/.ssh/id_ed25519"
      ];
    };
    programs = {
      fish.enable = true;
      nix-ld.enable = true;
    };

    security = {
      sudo-rs = {
        enable = true;
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
        ];

        experimental-features = "nix-command flakes";

        auto-optimise-store = true;
        use-xdg-base-directories = true;
        warn-dirty = false;

        substituters = [
          "https://cache.nixos.org/"
          "https://nix-community.cachix.org"
          "https://cache.nixos-cuda.org"
          "https://cache.numtide.com"
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        ];
      };

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
          editor = false;
          configurationLimit = 3;
          extraInstallCommands = ''
            for entry in /boot/loader/entries/nixos-generation-*.conf; do
              [ -e "$entry" ] || continue

              gen="$(${pkgs.coreutils}/bin/basename "$entry" \
                | ${pkgs.gnused}/bin/sed -E 's/^nixos-generation-([0-9]+).*\.conf$/\1/')"

              system_link="/nix/var/nix/profiles/system-$gen-link"

              if [ -e "$system_link" ]; then
                timestamp="$(${pkgs.coreutils}/bin/stat -c '%y' "$system_link" \
                  | ${pkgs.gawk}/bin/awk -F. '{print $1}' \
                  | ${pkgs.coreutils}/bin/tr ' ' '_')"

                ${pkgs.gnused}/bin/sed -i "s|^version .*|version $timestamp|" "$entry"
              fi
            done
          '';
        };
        efi.canTouchEfiVariables = true;
      };
      supportedFilesystems = ["ntfs" "btrfs"];
      initrd.systemd.enable = true; # Needed for hibernation
      kernelModules = ["ntsync"];
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
