{
  lib,
  config,
  ...
}: let
  overlay = final: prev: {
    "power-menu" = final.writeShellApplication {
      name = "power-menu";
      runtimeInputs = with final; [rofi systemd hyprlock];
      text = ''
        #!/bin/sh
        chosen=$(printf "  Lock\n⏾  Hibernate\n  Power Off\n  Restart\n󰋑  Logout\n⏾  Sleep" | rofi -dmenu -i)

        case "$chosen" in
          "⏾  Hibernate") systemctl hibernate && hyprlock ;;
          "  Power Off") poweroff ;;
          "  Restart") reboot ;;
          "⏾  Sleep") systemctl suspend && lock ;;
          "  Lock") lock ;;
          "󰋑  Logout") loginctl terminate-session "$XDG_SESSION_ID" ;;
          *) exit 1 ;;
        esac
      '';
    };
  };
in {
  my.overlays = lib.mkAfter [overlay];
  perSystem = {system, ...}: let pkgs = config.my.mkPkgs system; in {packages."power-menu" = pkgs."power-menu";};
}
