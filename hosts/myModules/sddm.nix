{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.myModules.sddm;
  sddmTheme = pkgs.sddm-theme;
in {
  options.myModules.sddm = {
    enable = lib.mkEnableOption "custom SDDM theme";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "${sddmTheme}";
      autoLogin.relogin = true;
      extraPackages = with pkgs; [
        libsForQt5.qt5.qtquickcontrols2
        libsForQt5.qt5.qtgraphicaleffects
      ];
    };
  };
}
