{
  lib,
  osConfig,
  ...
}: {
  xdg.configFile."hypr/hypridle.conf".text =
    ''
      general {
          lock_cmd = lock
          # unlock_cmd = notify-send "unlock!"
          before_sleep_cmd = lock
          # after_sleep_cmd = notify-send "Awake!"
          ignore_dbus_inhibit = false             # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
      }

      listener {
          timeout = 300
          on-timeout = brillo -O && brillo -u 200000 -S 1
          on-resume = brillo -u 200000 -I
      }

      listener {
          timeout = 315
          on-timeout =  lock
      }
    ''
    + (
      lib.optionalString (osConfig.networking.hostName == "xps") ''
        listener {
            timeout = 330
            on-timeout =  systemctl suspend
        }
      ''
    );
}
