{...}: {
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
}
