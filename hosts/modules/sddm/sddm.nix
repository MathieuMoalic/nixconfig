{pkgs, ...}: let
  sddmTheme = pkgs.stdenv.mkDerivation {
    name = "sddm-theme";
    src = ./theme;
    installPhase = ''
      mkdir -p $out
      cp -R $src/* $out/
    '';
  };
in {
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
}
