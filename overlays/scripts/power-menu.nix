{pkgs, ...}:
pkgs.writeShellApplication {
  name = "power-menu";
  runtimeInputs = with pkgs; [rofi systemd hyprlock];
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
}
