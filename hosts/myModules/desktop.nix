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
        var a = action.id;

        var allow = [
          // power actions
          "org.freedesktop.login1.reboot",
          "org.freedesktop.login1.reboot-multiple-sessions",
          "org.freedesktop.login1.power-off",
          "org.freedesktop.login1.power-off-multiple-sessions",

          // hibernate actions
          "org.freedesktop.login1.hibernate",
          "org.freedesktop.login1.hibernate-multiple-sessions",
          "org.freedesktop.login1.suspend-then-hibernate",
          "org.freedesktop.login1.suspend-then-hibernate-multiple-sessions",

          // suspend without prompt too
          "org.freedesktop.login1.suspend",
          "org.freedesktop.login1.suspend-multiple-sessions"
        ];

        if (allow.indexOf(a) !== -1 &&
            subject.active && subject.local &&
            subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
