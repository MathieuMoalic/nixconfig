{
  lib,
  stdenvNoCC,
  fetchurl,
}: let
  pname = "blaz";
  version = "0.1.3";
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/MathieuMoalic/blaz/releases/download/v${version}/blaz";
      sha256 = "sha256-KSGgcF0mI4aceWeu2IvCURiWlDucEXnDYYwljVrQvY0=";
    };

    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/bin"
      cp "$src" "$out/bin/blaz"
      chmod +x "$out/bin/blaz"
      runHook postInstall
    '';

    meta = with lib; {
      description = "blaz backend server";
      homepage = "https://github.com/MathieuMoalic/blaz";
      license = licenses.mit;
      platforms = ["x86_64-linux"];
      mainProgram = "blaz";
    };
  }
