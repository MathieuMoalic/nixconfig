{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.myModules.desktop;
in {
  options.myModules.desktop = {
    enable = lib.mkEnableOption "desktop";
  };

  config = lib.mkIf cfg.enable {
    myModules.sddm.enable = true;
    programs.hyprland = {
      enable = true;
      xwayland = {enable = true;};
      withUWSM = true;
    };
    environment = {
      systemPackages = with pkgs; [
        rose-pine-hyprcursor
      ];

      sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };
    fonts.packages = with pkgs; [
      corefonts # Arial, Times New Roman, etc.
      newcomputermodern # default overleaf font
      nerd-fonts.fira-code
      nerd-fonts.fira-mono # For waybar
      roboto
      font-awesome
      source-sans-pro
    ];
    security.pam.services.hyprlock = {}; # needed for hyprlock

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # make pipewire realtime-capable
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
    };
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
    };
  };
}
