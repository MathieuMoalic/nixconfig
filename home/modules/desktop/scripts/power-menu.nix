{pkgs, ...}: let
  power-menu = pkgs.writeShellScriptBin "power-menu" ''
    chosen=$(printf "  Lock\n⏾  Sleep\n  Power Off\n  Restart" | ${pkgs.rofi-wayland}/bin/rofi -dmenu -i)

    case "$chosen" in
    	"  Power Off") ${pkgs.systemd}/bin/poweroff ;;
    	"  Restart") ${pkgs.systemd}/bin/reboot ;;
    	"⏾  Sleep") ${pkgs.systemd}/bin/systemctl suspend && ${pkgs.swaylock}/bin/swaylock;;
    	"  Lock") ${pkgs.swaylock}/bin/swaylock;;
    	*) exit 1 ;;
    esac
  '';
in {
  home.packages = [
    power-menu
  ];
}
