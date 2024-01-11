{
  config,
  pkgs,
  ...
}: {
  services.swayidle = {
    enable = true;
    # timeouts = [
    #   {
    #     timeout = 20;
    #     command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
    #   }
    #   {
    #     timeout = 30;
    #     command = "${pkgs.systemd}/bin/systemctl suspend";
    #   }
    # ];
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
