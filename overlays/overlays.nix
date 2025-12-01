inputs: self: super: let
  inherit (super) lib;

  # Use the new, non-deprecated way to get the system
  system = super.stdenv.hostPlatform.system;

  scriptsPath = ./scripts;
  pkgsPath = ../pkgs;

  # autodiscover ./scripts/*.nix -> pkgs.<name>
  scriptDirEntries = builtins.readDir scriptsPath;

  scriptPackages =
    lib.foldlAttrs
    (
      acc: fileName: fileType:
        if fileType == "regular" && lib.hasSuffix ".nix" fileName
        then let
          packageName = lib.removeSuffix ".nix" fileName;
        in
          acc
          // {
            ${packageName} =
              super.callPackage (scriptsPath + "/${fileName}") {};
          }
        else acc
    )
    {}
    scriptDirEntries;

  # autodiscover ../pkgs:
  # - regular *.nix files -> attr name without .nix
  # - directories -> attr name = directory name, expects default.nix inside
  pkgsDirEntries = builtins.readDir pkgsPath;

  autoPkgs =
    lib.foldlAttrs
    (
      acc: fileName: fileType:
        if fileType == "regular" && lib.hasSuffix ".nix" fileName
        then let
          packageName = lib.removeSuffix ".nix" fileName;
        in
          acc
          // {
            ${packageName} =
              super.callPackage (pkgsPath + "/${fileName}") {};
          }
        else if fileType == "directory"
        then
          acc
          // {
            ${fileName} =
              super.callPackage (pkgsPath + "/${fileName}") {};
          }
        else acc
    )
    {}
    pkgsDirEntries;
in
  {
    amumax =
      inputs.amumax.packages.${system}.git;

    nvim-unstable =
      inputs.nixpkgs_unstable.legacyPackages.${system}.neovim-unwrapped;

    inherit (inputs.quicktranslate.packages.${system}) quicktranslate;

    rose-pine-hyprcursor =
      inputs.rose-pine-hyprcursor.packages.${system}.default;

    zjstatus =
      inputs.zjstatus.packages.${system}.default;
  }
  // scriptPackages
  // autoPkgs
