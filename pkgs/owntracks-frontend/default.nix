{
  buildNpmPackage,
  fetchFromGitHub,
  nodejs ? null, # override to pkgs.nodejs_20 if you want
}:
buildNpmPackage rec {
  pname = "owntracks-frontend";
  version = "2.15.3";

  src = fetchFromGitHub {
    owner = "owntracks";
    repo = "frontend";
    rev = "v${version}";
    # Fill this after first build attempt
    hash = "sha256-omNsCD6sPwPrC+PdyftGDUeZA8nOHkHkRHC+oHFC0eM=";
  };

  # The project uses npm + package-lock.json
  npmDepsHash = "sha256-sZkOvffpRoUTbIXpskuVSbX4+k1jiwIbqW4ckBwnEHM=";

  npmBuildScript = "build";

  # (Optional) pin Node if your nixpkgs default is too new/old
  inherit nodejs;

  # Result: just the built static site
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/owntracks-frontend
    cp -r dist/* $out/share/owntracks-frontend/
    runHook postInstall
  '';
}
