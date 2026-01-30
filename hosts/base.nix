{
  lib,
  inputs,
  ...
}: let
  helpers = import ./myModules/helper.nix {inherit lib;};
in {
  # This replaces the “global modules list” you previously built inside flake.nix.
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      inputs.homepage.nixosModules.homepage-service
      inputs.pleustradenn.nixosModules.pleustradenn-service
      inputs.boued.nixosModules.boued-service
      inputs.sops-nix.nixosModules.sops
      inputs.disko.nixosModules.disko
    ]
    ++ helpers.moduleListFromDir {dir = ./myModules;};

  # This replaces the inline module in flake.nix that injected home/myModules.
  home-manager.users.mat.imports =
    helpers.moduleListFromDir {dir = ../home/myModules;};
}
