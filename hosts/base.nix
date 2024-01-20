{
  inputs,
  pkgs,
  ...
}: {
  # services.pcscd = {
  #   enable = true;
  # };
  # security.polkit.extraConfig = ''
  #   polkit.addRule(function(action, subject) {
  #     if (action.id == "org.debian.pcsc-lite.access_pcsc" &&
  #       subject.isInGroup("wheel")) {
  #       return polkit.Result.YES;
  #     }
  #   });
  # '';

  programs.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    package = pkgs.hyprland;
    xwayland = {enable = true;};
  };

  boot.supportedFilesystems = ["ntfs"];

  fonts.packages = with pkgs; [
    corefonts
    proggyfonts
    nerdfonts
    fira-code
  ];
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

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

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
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };

  environment.binsh = "${pkgs.dash}/bin/dash";

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

  xdg.portal = {
    enable = true;
    # extraPortals = [pkgs.xdg-desktop-portal-hyprland];
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
  environment.variables = {ZDOTDIR = "$HOME/.config/zsh";};

  environment.systemPackages = with pkgs; [
    home-manager
    pcsclite
  ];
}
