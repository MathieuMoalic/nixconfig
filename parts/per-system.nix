{config, ...}: {
  perSystem = {system, ...}: let
    pkgs = config.my.mkPkgs system;
  in {
    formatter = pkgs.alejandra;

    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        alejandra
        nh
        git
        sops
        just
      ];
    };
  };
}
