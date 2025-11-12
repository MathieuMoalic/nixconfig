{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}: let
  upstream = fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-sugar-dark";
    rev = "v1.2";
    hash = lib.fakeSha256;
  };

  background = builtins.fetchurl {
    url = "https://github.com/user-attachments/assets/bab293e8-a137-4185-8728-ac5359894c39";
    sha256 = "sha256-mhDnSte2Auoc8Dom5LJ/yoK7BjiKZmwDsIdzHgtqBQg=";
  };

  myThemeConf = ./theme.conf;
in
  stdenvNoCC.mkDerivation {
    pname = "sddm-theme";
    version = "1.0";

    src = upstream;

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"

      cp -R "$src"/* "$out/"

      # Apply your Main.qml tweaks
      qml="$out/Main.qml"
      [ -f "$qml" ] || qml="$out/Main.qml"
      if [ -f "$qml" ]; then
        substituteInPlace "$qml" \
          --replace 'palette.window: "#444"' 'palette.window: config.BackgroundColor' \
          --replace 'color: "#444"'          'color: config.BackgroundColor'
      else
        echo "warning: Main.qml not found; skipping qml tweaks" >&2
      fi

      # Use your own theme.conf (overwrites upstream one if present)
      cp ${myThemeConf} "$out/theme.conf"

      # Override background
      cp ${background} "$out/Background.jpg"

      runHook postInstall
    '';
  }
