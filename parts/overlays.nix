{
  lib,
  inputs,
  ...
}: let
  localPkgsDir = ./_pkgs;

  localOverlay = final: prev: let
    inherit (prev) lib;
    system = final.stdenv.hostPlatform.system;

    entries = builtins.readDir localPkgsDir;

    fromFiles =
      lib.foldlAttrs
      (
        acc: fileName: fileType:
          if fileType == "regular" && lib.hasSuffix ".nix" fileName
          then let
            attr = lib.removeSuffix ".nix" fileName;
          in
            acc // {${attr} = final.callPackage (localPkgsDir + "/${fileName}") {};}
          else acc
      )
      {}
      entries;

    # optional: support dirs with default.nix (only when you truly need multi-file pkgs)
    fromDirs =
      lib.foldlAttrs
      (
        acc: name: t:
          if t == "directory" && builtins.pathExists (localPkgsDir + "/${name}/default.nix")
          then acc // {${name} = final.callPackage (localPkgsDir + "/${name}") {};}
          else acc
      )
      {}
      entries;
  in
    fromFiles
    // fromDirs
    // {
      amumax = inputs.amumax.packages.${system}.git;
      nvim-unstable = inputs.nixpkgs_unstable.legacyPackages.${system}.neovim-unwrapped;
      quicktranslate = inputs.quicktranslate.packages.${system}.quicktranslate;
      rose-pine-hyprcursor = inputs.rose-pine-hyprcursor.packages.${system}.default;
      zjstatus = inputs.zjstatus.packages.${system}.default;
    };
in {
  options.my.overlays = lib.mkOption {
    type = lib.types.listOf lib.types.raw;
    default = [];
    description = "Overlays applied by mkPkgs and exported by the flake.";
  };

  config = {
    my.overlays = [localOverlay];
    flake.overlays.default = localOverlay;
  };
}
