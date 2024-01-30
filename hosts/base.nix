{pkgs, ...}: {
  security.sudo.wheelNeedsPassword = false;
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

  nixpkgs.config.allowUnfree = true;

  nix = {
    channel.enable = false;
    package = pkgs.nix;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      use-xdg-base-directories = true;
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
        "https://hyprland.cachix.org"
        "https://helix.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      ];
    };
  };

  environment.binsh = "${pkgs.dash}/bin/dash";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"];

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
    uid = 1000;
    description = "mat";
    group = "mat";
    extraGroups = ["networkmanager" "wheel" "video" "input" "uinput"];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
  environment.variables = {ZDOTDIR = "$HOME/.config/zsh";};
  environment.systemPackages = with pkgs; [
    home-manager
  ];
}
