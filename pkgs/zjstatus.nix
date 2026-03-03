{
  flake.overlays.zjstatus = final: _: {
    zjstatus = final.stdenvNoCC.mkDerivation {
      pname = "zjstatus";
      version = "0.22.0";

      src = final.fetchurl {
        url = "https://github.com/dj95/zjstatus/releases/download/v0.22.0/zjstatus.wasm";
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
}
