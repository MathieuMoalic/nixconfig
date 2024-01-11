{
  config,
  pkgs,
  wallpaperPath,
  ...
}: {
  systemd.user.services.lock-before-sleep = {
    Unit = {
      Description = "Lock the screen before sleep";
      Before = ["sleep.target"];
    };

    Service = {
      Type = "simple";
      Environment = "DISPLAY=:0";
      ExecStart = "${pkgs.swaylock-effects}/bin/swaylock -C /home/mat/.config/swaylock/config";
    };

    Install = {
      WantedBy = ["suspend.target"];
    };
  };
  programs.swaylock = with config.colorScheme.colors; {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      # image = "~/.local/share/wallpaper.jpeg";
      image = "${wallpaperPath}";
      ignore-empty-password = true;
      font = "Ubuntu";
      indicator-radius = 300;
      indicator-thickness = 70;
      indicator-caps-lock = true;
      key-hl-color = "${base08}";
      separator-color = "00000000";
      inside-color = "${base00}88";
      inside-clear-color = "${orange}00";
      inside-caps-lock-color = "${base0C}00";
      inside-ver-color = "${base0B}00";
      inside-wrong-color = "${base08}00";
      ring-color = "${base00}D9";
      ring-clear-color = "${orange}D9";
      ring-caps-lock-color = "8ec07cD9";
      ring-ver-color = "${base0B}D9";
      ring-wrong-color = "${base08}D9";
      line-color = "000000FF";
      line-clear-color = "${orange}FF";
      line-caps-lock-color = "${base0C}FF";
      line-ver-color = "${base0B}FF";
      line-wrong-color = "${base08}FF";
      text-clear-color = "${base00}D9";
      text-ver-color = "${base0B}00";
      text-wrong-color = "${base08}00";
      bs-hl-color = "${base08}FF";
      caps-lock-key-hl-color = "${orange}FF";
      caps-lock-bs-hl-color = "${base08}FF";
      disable-caps-lock-text = true;
      text-caps-lock-color = "${base0C}";
      # swaylock-effect specific options
      fade-in = 0.2;
      clock = true;
      effect-blur = "20x2";
      effect-scale = 0.3;
      indicator = true;
    };
  };
}
