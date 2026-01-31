{inputs, ...}: let
  lib = inputs.nixpkgs.lib;
  helpers = import ../../hosts/myModules/helper.nix {inherit lib;};
in {
  flake.nixosModules =
    helpers.mkModulesFromDir {dir = ../../hosts/myModules;};
}
