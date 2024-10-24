{pkgs, ...}: let
  background = pkgs.fetchurl {
    url = "https://github.com/user-attachments/assets/bab293e8-a137-4185-8728-ac5359894c39";
    sha256 = "sha256-mhDnSte2Auoc8Dom5LJ/yoK7BjiKZmwDsIdzHgtqBQg=";
  };
  sddmTheme = pkgs.stdenv.mkDerivation {
    name = "sddm-theme";
    src = ./theme;
    installPhase = ''
      mkdir -p $out
      cp -R $src/* $out/
      cp -r ${background} $out/Background.jpg
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
