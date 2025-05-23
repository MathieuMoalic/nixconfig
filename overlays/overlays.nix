inputs: self: super: let
  lib = super.lib;
  scriptsPath = ./scripts;
  scriptPackages = let
    scriptDirEntries = builtins.readDir scriptsPath;
  in
    lib.foldlAttrs (
      acc: fileName: fileType:
        if fileType == "regular" && lib.hasSuffix ".nix" fileName
        then let
          packageName = lib.removeSuffix ".nix" fileName;
        in
          acc // {${packageName} = super.callPackage (scriptsPath + "/${fileName}") {};}
        else acc
    )
    {}
    scriptDirEntries;
in
  {
    amumax = inputs.amumax.packages.${self.system}.default;
    nvim-unstable = inputs.nixpkgs_unstable.legacyPackages.${self.system}.neovim-unwrapped;
    quicktranslate = inputs.quicktranslate.packages.${self.system}.quicktranslate;
    rose-pine-hyprcursor = inputs.rose-pine-hyprcursor.packages.${self.system}.default;
  }
  // scriptPackages
