{
  lib,
  osConfig,
  ...
}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "lock";
        before_sleep_cmd = "lock";
        # after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 3600;
          on-timeout = "lock";
        }
      ];
    };
  };
  # xdg.configFile."hypr/hypridle.conf".text =
  #   ''
  #     general {
  #         lock_cmd = lock
  #         # unlock_cmd = notify-send "unlock!"
  #         before_sleep_cmd = lock
  #         # after_sleep_cmd = notify-send "Awake!"
  #         ignore_dbus_inhibit = false             # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
  #     }

  #     listener {
  #         timeout = 3600
  #         on-timeout =  lock
  #     }
  #   ''
  #   + (
  #     lib.optionalString (osConfig.networking.hostName == "xps") ''
  #       listener {
  #           timeout = 3660
  #           on-timeout =  systemctl suspend
  #       }
  #     ''
  #   );
}
