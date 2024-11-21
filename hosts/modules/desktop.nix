{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    xwayland = {enable = true;};
    withUWSM = true;
  };
  fonts.packages = with pkgs; [
    corefonts # Arial, Times New Roman, etc.
    (nerdfonts.override {fonts = ["FiraCode" "FiraMono"];}) # FiraMono is for waybar
    roboto
    font-awesome
    source-sans-pro
  ];
  security.pam.services.hyprlock = {}; # needed for hyprlock

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # make pipewire realtime-capable
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    extraConfig = "DefaultTimeoutStopSec=10s";
  };
}
