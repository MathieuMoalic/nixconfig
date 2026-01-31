{
  lib,
  config,
  ...
}: let
  overlay = final: prev: {
    watcharr = let
      pname = "watcharr";
      version = "2.1.1";

      src = final.fetchFromGitHub {
        owner = "sbondCo";
        repo = "Watcharr";
        rev = "v${version}";
        hash = "sha256-vuqymvPxQwWgmNvr6wNk5P2TFyCYkj0K5ncb3Q1eRbs=";
      };

      ui = final.buildNpmPackage {
        pname = "${pname}-ui";
        inherit version src;
        nodejs = final.nodejs_20;

        npmDepsHash = "sha256-vUbkTUaDQbvfc439ufLVGUR0Z/l3LlLE72fcc7m1o50=";

        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp -r build $out/
          runHook postInstall
        '';
      };
    in
      final.buildGoModule {
        inherit pname version src;

        modRoot = "server";
        subPackages = ["."];

        vendorHash = "sha256-DaKPl0Th85WOXfAactTSYNOmQcz9Yh0mydTCVkMkbQA=";

        env.CGO_ENABLED = 1;
        env.CGO_CFLAGS = "-D_LARGEFILE64_SOURCE";

        nativeBuildInputs = [final.pkg-config];
        buildInputs = [final.sqlite];

        preBuild = ''
          mkdir -p ui
          cp -r ${ui}/build/. ui/
        '';

        postInstall = ''
          mkdir -p "$out/ui"
          cp -r ${ui}/build/. "$out/ui/"
        '';

        meta = with final.lib; {
          description = "Self-hostable watched list (movies, TV, anime, games)";
          homepage = "https://watcharr.app";
          license = licenses.mit;
          platforms = platforms.linux;
          mainProgram = "server";
        };
      };
  };
in {
  my.overlays = lib.mkAfter [overlay];
  perSystem = {system, ...}: let pkgs = config.my.mkPkgs system; in {packages.watcharr = pkgs.watcharr;};
}
