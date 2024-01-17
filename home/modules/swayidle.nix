{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 60 * 5; # lock after 5 minutes
        command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
      }
      (
        lib.optionals (osConfig.networking.hostName == "xps")
        {
          timeout = 60 * 6; # Sleep after 6 min if xps
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      )
    ];
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock-effects}/bin/swaylock";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock-effects}/bin/swaylock";
      }
    ];
  };
}
