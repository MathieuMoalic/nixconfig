{
  lib,
  config,
  ...
}: let
  overlay = final: prev: {
    "sddm-theme" = final.stdenvNoCC.mkDerivation {
      pname = "sddm-theme";
      version = "1.0";

      src = final.fetchFromGitHub {
        owner = "MarianArlt";
        repo = "sddm-sugar-dark";
        rev = "v1.2";
        hash = "sha256-C3qB9hFUeuT5+Dos2zFj5SyQegnghpoFV9wHvE9VoD8=";
      };

      background = builtins.fetchurl {
        url = "https://github.com/user-attachments/assets/bab293e8-a137-4185-8728-ac5359894c39";
        sha256 = "sha256-mhDnSte2Auoc8Dom5LJ/yoK7BjiKZmwDsIdzHgtqBQg=";
      };

      myThemeConf = builtins.toFile "theme.conf" ''
        [General]
        Background="Background.jpg"
        ScaleImageCropped=true
        MainColor="#f8f8f2"
        AccentColor="#50fa7b"
        BackgroundColor="#282a36"
        RoundCorners=20
        ScreenPadding=0
        # have to be available to the X root user
        Font="Noto Sans"
        # keep empty
        FontSize=
        Locale=
        #  http://doc.qt.io/qt-5/qml-qtqml-date.html
        HourFormat="HH:mm"
        DateFormat="dd/MM/yyyy"
        ForceRightToLeft=false
        ForceLastUser=true
        ForcePasswordFocus=true
        ForceHideCompletePassword=true
        ForceHideVirtualKeyboardButton="false"
      '';

      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall
        mkdir -p "$out"

        cp -R --no-preserve=mode "$src"/* "$out/"

        qml="$out/Main.qml"
        if [ ! -f "$qml" ]; then
          qml="$out/Sugar-Dark/Main.qml"
        fi

        if [ -f "$qml" ]; then
          substituteInPlace "$qml" \
            --replace-warn 'palette.window: "#444"' 'palette.window: config.BackgroundColor' \
            --replace-warn 'color: "#444"'          'color: config.BackgroundColor'
        else
          echo "warning: Main.qml not found; skipping qml tweaks" >&2
        fi

        rm -f "$out/theme.conf"
        install -Dm0644 ${"$"}{myThemeConf} "$out/theme.conf"

        install -Dm0644 ${"$"}{background} "$out/Background.jpg"

        runHook postInstall
      '';
    };
  };
in {
  my.overlays = lib.mkAfter [overlay];
  perSystem = {system, ...}: let pkgs = config.my.mkPkgs system; in {packages."sddm-theme" = pkgs."sddm-theme";};
}
