{
  lib,
  config,
  ...
}: let
  overlay = final: prev: {
    sopsedit = final.writeShellApplication {
      name = "sopsedit";
      runtimeInputs = with final; [sops];
      text = ''
        sudo SOPS_AGE_KEY_FILE=/var/lib/sops-nix/age_key sops /home/mat/nix/secrets.yaml
      '';
    };
  };
in {
  my.overlays = lib.mkAfter [overlay];
  perSystem = {system, ...}: let pkgs = config.my.mkPkgs system; in {packages.sopsedit = pkgs.sopsedit;};
}
