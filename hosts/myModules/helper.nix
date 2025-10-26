{lib}: let
  inherit (lib) filterAttrs mapAttrs' nameValuePair elem;
  strings = lib.strings;
in rec {
  # Build an attrset of modules from a directory
  mkModulesFromDir = {
    dir,
    exclude ? ["helper.nix"],
    includeDefaultDirs ? true,
  }: let
    entries = builtins.readDir dir;
    selected =
      filterAttrs (
        n: t:
          (t == "regular" && strings.hasSuffix ".nix" n && !(elem n exclude))
          || (includeDefaultDirs
            && t == "directory"
            && builtins.pathExists (dir + "/${n}/default.nix")
            && !(elem (n + "/") exclude))
      )
      entries;
  in
    mapAttrs' (
      n: t:
        if t == "regular"
        then nameValuePair (strings.removeSuffix ".nix" n) (import (dir + "/${n}"))
        else nameValuePair n (import (dir + "/${n}"))
    )
    selected;

  # Build a (stable, sorted) list of modules from a directory
  moduleListFromDir = {
    dir,
    exclude ? ["helper.nix"],
    includeDefaultDirs ? true,
    sort ? true,
    trace ? false,
  }: let
    mods0 = mkModulesFromDir {inherit dir exclude includeDefaultDirs;};
    mods =
      if trace
      then builtins.trace "Auto-importing modules from ${toString dir}" mods0
      else mods0;
    names = builtins.attrNames mods;
    names' =
      if sort
      then builtins.sort builtins.lessThan names
      else names;
  in
    map (n: mods.${n}) names';
}
