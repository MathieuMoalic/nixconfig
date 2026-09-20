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

      specialArgs = {
        inherit inputs self;
      };

      modules =
        [
          inputs.home-manager.nixosModules.home-manager

          {
            home-manager.extraSpecialArgs = {
              inherit inputs self;
            };
          }

          inputs.sops-nix.nixosModules.sops

          self.nixosModules.base

          {
            networking.hostName = hostName;
            system.stateVersion = stateVersion;
            nixpkgs.overlays =
              [
                (
                  final: prev: {
                    llm-agents = inputs.llm-agents.packages.${system};
                  }
                )

                (
                  final: prev: {
                    unstable = inputs.nixpkgs_unstable.legacyPackages.${system};
                  }
                )
              ]
              ++ builtins.attrValues (removeAttrs self.overlays ["default"]);
          }

          hostConfig
        ]
        ++ nixosModules
        ++ userModules;
    };
in {
  flake.lib.mkHost = mkHost;
}
