{
  flake.overlays.zjstatus = final: _: {
    zjstatus = final.stdenvNoCC.mkDerivation {
      pname = "zjstatus";
      version = "0.23.0";

      src = final.fetchurl {
        url = "https://github.com/dj95/zjstatus/releases/download/v0.23.0/zjstatus.wasm";
        hash = "sha256-4AaQEiNSQjnbYYAh5MxdF/gtxL+uVDKJW6QfA/E4Yf8=";
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
