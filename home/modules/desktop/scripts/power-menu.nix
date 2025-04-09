{pkgs, ...}:
pkgs.writeShellApplication {
  name = "power-menu";
  runtimeInputs = with pkgs; [rofi-wayland systemd];
  text = ''
    #!/bin/sh
    chosen=$(printf "  Lock\n⏾  Sleep\n  Power Off\n  Restart\n󰋑  Logout\n⏾ Hibernate" | rofi -dmenu -i)

    case "$chosen" in
      "  Power Off") poweroff ;;
      "  Restart") reboot ;;
      "⏾  Sleep") systemctl suspend && lock ;;
      "  Lock") lock ;;
      "󰋑  Logout") loginctl terminate-session "$XDG_SESSION_ID" ;;
      "⏾ Hibernate") systemctl hibernate && lock ;;
      *) exit 1 ;;
    esac
  '';
}
