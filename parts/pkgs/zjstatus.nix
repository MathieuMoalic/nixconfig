{
  lib,
  config,
  ...
}: let
  overlay = final: _prev: {
    zjstatus = let
      pname = "zjstatus";
      version = "0.22.0";
    in
      final.stdenvNoCC.mkDerivation {
        inherit pname version;

        src = final.fetchurl {
          url = "https://github.com/dj95/zjstatus/releases/download/v${version}/zjstatus.wasm";

          hash = "sha256-TeQm0gscv4YScuknrutbSdksF/Diu50XP4W/fwFU3VM=";
        };

        dontUnpack = true;

        installPhase = ''
          runHook preInstall
          install -Dm444 "$src" "$out/bin/zjstatus.wasm"
          runHook postInstall
        '';

        meta = with final.lib; {
          description = "Prebuilt zjstatus WASM plugin for zellij";
          homepage = "https://github.com/dj95/zjstatus";
          license = licenses.mit;
          platforms = platforms.all;
        };
      };
  };
in {
  my.overlays = lib.mkAfter [overlay];

  perSystem = {system, ...}: let
    pkgs = config.my.mkPkgs system;
  in {
    packages.zjstatus = pkgs.zjstatus;
    packages.default = pkgs.zjstatus;
  };
}
