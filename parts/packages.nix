{config, ...}: {
  perSystem = {system, ...}: let
    pkgs = config.my.mkPkgs system;
    lib = pkgs.lib;

    dir = ./_pkgs;
    entries = builtins.readDir dir;

    fileNames =
      builtins.attrNames (lib.filterAttrs (n: t: t == "regular" && lib.hasSuffix ".nix" n) entries);

    dirNames =
      builtins.attrNames (lib.filterAttrs (n: t: t == "directory" && builtins.pathExists (dir + "/${n}/default.nix")) entries);

    localNames = (map (n: lib.removeSuffix ".nix" n) fileNames) ++ dirNames;

    overlayExtras = [
      "amumax"
      "quicktranslate"
      "zjstatus"
      "nvim-unstable"
      "rose-pine-hyprcursor"
    ];

    exported = lib.filter (n: pkgs ? "${n}") (localNames ++ overlayExtras);
  in {
    packages = lib.genAttrs exported (n: pkgs.${n});
  };
}
