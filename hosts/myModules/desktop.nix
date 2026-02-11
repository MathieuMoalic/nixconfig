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
    myModules.lemurs.enable = true;
    programs.hyprland = {
      enable = true;
      xwayland = {enable = true;};
      withUWSM = true;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

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

    # Bluetooth (BlueZ)
    services.blueman.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # make pipewire realtime-capable
    security.rtkit.enable = true;
    services.pulseaudio.enable = false;

    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      wireplumber.enable = true;
      wireplumber.configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/90-bluez-seat.conf" ''
          wireplumber.profiles = {
            main = {
              monitor.bluez.seat-monitoring = disabled
            }
          }
        '')
      ];
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

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (!subject.isInGroup("wheel")) return null;

        // login1 path
        var allowLogin1 = [
          "org.freedesktop.login1.suspend",
          "org.freedesktop.login1.suspend-multiple-sessions",
          "org.freedesktop.login1.hibernate",
          "org.freedesktop.login1.hibernate-multiple-sessions",
          "org.freedesktop.login1.suspend-then-hibernate",
          "org.freedesktop.login1.suspend-then-hibernate-multiple-sessions",
          "org.freedesktop.login1.hibernate-ignore-inhibit"
        ];

        if (allowLogin1.indexOf(action.id) !== -1) {
          return polkit.Result.YES;
        }

        // systemd fallback used by `systemctl hibernate`
        if (action.id === "org.freedesktop.systemd1.manage-units") {
          var verb = action.lookup("verb");
          var unit = action.lookup("unit");
          if (verb === "start" && (unit === "hibernate.target" || unit === "suspend-then-hibernate.target")) {
            return polkit.Result.YES;
          }
        }

        return null;
      });
    '';
  };
}
