{pkgs, ...}: let
  script = pkgs.writeShellApplication {
    name = "power-menu";
    runtimeInputs = with pkgs; [rofi-wayland systemd];
    text = ''
      chosen=$(printf "  Lock\n⏾  Sleep\n  Power Off\n  Restart" | rofi -dmenu -i)

      case "$chosen" in
      	"  Power Off") poweroff ;;
      	"  Restart") reboot ;;
      	"⏾  Sleep") systemctl suspend && lock;;
      	"  Lock") lock;;
      	*) exit 1 ;;
      esac
    '';
  };
in {
  home.packages = [
    script
  ];
}
