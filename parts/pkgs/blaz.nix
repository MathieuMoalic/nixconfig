{
  lib,
  config,
  ...
}: let
  overlay = final: prev: {
    blaz = final.stdenvNoCC.mkDerivation {
      pname = "blaz";
      version = "0.1.3";

      src = final.fetchurl {
        url = "https://github.com/MathieuMoalic/blaz/releases/download/v0.1.3/blaz";
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

      meta = with final.lib; {
        description = "blaz backend server";
        homepage = "https://github.com/MathieuMoalic/blaz";
        license = licenses.mit;
        platforms = ["x86_64-linux"];
        mainProgram = "blaz";
      };
    };
  };
in {
  my.overlays = lib.mkAfter [overlay];
  perSystem = {system, ...}: let pkgs = config.my.mkPkgs system; in {packages.blaz = pkgs.blaz;};
}
