{stdenvNoCC}: let
  background = builtins.fetchurl {
    url = "https://github.com/user-attachments/assets/bab293e8-a137-4185-8728-ac5359894c39";
    sha256 = "sha256-mhDnSte2Auoc8Dom5LJ/yoK7BjiKZmwDsIdzHgtqBQg=";
  };
in
  stdenvNoCC.mkDerivation {
    pname = "sddm-theme";
    version = "1.0";

    # theme directory sits next to this file
    src = ./theme;

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp -R "$src"/* "$out/"
      cp -r ${background} "$out/Background.jpg"
      runHook postInstall
    '';
  }
