{pkgs, ...}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # Start hyprlock if not already running
        lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";

        # Lock the session before suspend/hibernate events
        before_sleep_cmd = "loginctl lock-session";

        # Strongly recommended for your crash pattern:
        # wait until the session is actually locked
        inhibit_sleep = 3;

        ignore_dbus_inhibit = false;

        # optional convenience (prevents “press a key twice” cases)
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        # Idle lock after 1h
        {
          timeout = 3600;
          on-timeout = "loginctl lock-session";
        }

        # Optional: turn displays off shortly after locking
        # { timeout = 3630; on-timeout = "hyprctl dispatch dpms off"; on-resume = "hyprctl dispatch dpms on"; }
      ];
    };
  };
}
