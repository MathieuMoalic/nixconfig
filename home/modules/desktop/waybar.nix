{
  config,
  lib,
  pkgs,
  ...
}: let
  theme = config.colorScheme.palette;
in {
  wayland.windowManager.hyprland.settings.exec-once = lib.mkAfter ["${pkgs.waybar}/bin/waybar"];
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      #waybar {
        font-family: "FiraMono Nerd Font", sans-serif;
        font-size: 1.2em;
        font-weight: 600;
        color: #${theme.base05};
        border-radius: 0;
        background: rgba(40, 42, 54, 0.7);
      }

      #mode,
      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #idle_inhibitor,
      #backlight,
      #custom-storage,
      #custom-updates,
      #custom-weather,
      #custom-mail,
      #clock,
      #temperature,
      #window {
        /* top | right | bottom | left */
        margin: 4px 10px 0px 10px;
        min-width: 50px;
      }

      #workspaces button {
        color: #${theme.base05};
        border-radius: 0;
      }

      #workspaces button.active {
        color: #${theme.base00};
        background-color: #${theme.base05};
        opacity: 0.5;
      }

      #workspaces button.urgent {
        color: #${theme.base09};
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;
        spacing = 4;
        modules-left = ["hyprland/workspaces" "hyprland/window"];
        modules-center = [];
        modules-right = [
          "custom/brightness"
          "pulseaudio"
          "custom/vpn"
          "network"
          "battery"
          "clock"
        ];

        "wlr/workspaces" = {
          "disable-scroll" = true;
          "on-click" = "activate";
          format = "{name}";
          "on-scroll-up" = "hyprctl dispatch workspace m-1 > /dev/null";
          "on-scroll-down" = "hyprctl dispatch workspace m+1 > /dev/null";
          "format-icons" = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            urgent = "";
            focused = "";
            default = "";
          };
        };

        "hyprland/window" = {
          "max-length" = 50;
          "separate-outputs" = true;
        };

        clock = {
          format = " {:%Y.%m.%d |   %H:%M:%S}";
          interval = 1;
          "tooltip-format" = "<tt>{calendar}</tt>";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon} |";
          "format-charging" = "{capacity}% 󰂅 |";
          "format-plugged" = "{capacity}%  |";
          "format-alt" = "{time} {icon} |";
          "format-icons" = [" " " " " " " " " "];
        };

        pulseaudio = {
          format = "{volume}% {icon}  |";
          "format-bluetooth" = "{volume}% {icon}  |";
          "format-muted" = "{volume}% 󰖁  |";
          "format-icons" = {
            headphone = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" ""];
          };
          "scroll-step" = 1;
          "on-click" = "pactl set-sink-mute 0 toggle";
          "ignored-sinks" = ["Easy Effects Sink"];
        };

        network = {
          format = "";
          "format-alt" = "{ifname}: {ipaddr}/{cidr} |";
          "format-wifi" = "  |";
          "format-ethernet" = "{ipaddr}/{cidr} 󰈁 |";
          "format-disconnected" = " 󰈂 |";
          tooltip = false;
        };

        "custom/brightness" = {
          format = "{}%  |";
          tooltip = false;
          exec = "brillo -q | cut -d'.' -f1";
          interval = "once";
          "exec-on-event" = true;
          "on-scroll-up" = "brillo -q -A 0.2";
          "on-scroll-down" = "brillo -q -U 0.2";
        };

        "custom/vpn" = {
          interval = 5;
          "on-click" = "wireguard-menu";
          exec = "nmcli connection show | awk '/wireguard/ {printf \"%s: %s | \", $1, ($4 == \"--\" ? \"󰿆\" : \"󰌾\")}'";
        };
      };
    };
  };
}
