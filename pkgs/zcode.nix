{...}: {
  flake.overlays.zcode = final: prev: let
    version = "3.14.0";

    src = prev.fetchurl {
      url = "https://cdn-zcode.z.ai/zcode/electron/releases/${version}/linux-x64/ZCode-${version}-linux-x64.AppImage";
      sha256 = "0ybwyn9vz6mpxw3nbzl4z5ssg7mqw09iz3jzajdrx3hhwxwv04hq";
    };

    appimageContents = prev.appimageTools.extract {
      pname = "zcode";
      inherit version src;
    };
  in {
    zcode = prev.appimageTools.wrapType2 {
      pname = "zcode";
      inherit version src;

      extraInstallCommands = ''
        install -Dm444 ${appimageContents}/zcode.desktop -t $out/share/applications/

        substituteInPlace $out/share/applications/zcode.desktop \
          --replace-fail 'Exec=AppRun' 'Exec=zcode'
      '';

      meta = {
        changelog = "https://zcode.z.ai/releases";
        platforms = ["x86_64-linux"];
        license = prev.lib.licenses.unfree;
      };
    };
  };
}
