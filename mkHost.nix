{
  inputs,
  self,
  lib,
  ...
}: let
  mkHost = {
    hostName,
    system,
    stateVersion,
    nixosModules,
    userModules,
    hostConfig,
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs self;};

      modules =
        [
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
          inputs.disko.nixosModules.disko
          self.nixosModules.base
          {
            networking.hostName = hostName;
            system.stateVersion = stateVersion;
            nixpkgs.overlays = [
              (lib.composeManyExtensions
                (builtins.attrValues (removeAttrs self.overlays ["default"])))
            ];
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }

          hostConfig
        ]
        ++ nixosModules
        ++ userModules;
    };
in {
  flake.lib.mkHost = mkHost;
}
