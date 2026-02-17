{
  lib,
  inputs,
  config,
  ...
}: {
  options.my.nixos.mkHost = lib.mkOption {
    type = lib.types.raw;
    readOnly = true;
  };

  config.my.nixos.mkHost = hostModule: let
    baseModule = {
      lib,
      inputs,
      ...
    }: let
      helpers = import ../../hosts/myModules/helper.nix {inherit lib;};
    in {
      imports =
        [
          inputs.home-manager.nixosModules.home-manager
          inputs.homepage.nixosModules.homepage-service
          inputs.pleustradenn.nixosModules.pleustradenn-service
          inputs.blaz.nixosModules.blaz-service
          inputs.boued.nixosModules.boued-service
          inputs.sops-nix.nixosModules.sops
          inputs.disko.nixosModules.disko
        ]
        ++ helpers.moduleListFromDir {dir = ../../hosts/myModules;};

      home-manager.users.mat.imports =
        helpers.moduleListFromDir {dir = ../../home/myModules;};
    };
  in
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      pkgs = config.my.mkPkgs "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        baseModule
        hostModule
      ];
    };
}
