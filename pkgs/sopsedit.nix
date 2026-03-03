{...}: let
  overlay = final: _: {
    sopsedit = final.writeShellApplication {
      name = "sopsedit";
      runtimeInputs = with final; [sops];
      text = ''
        sudo SOPS_AGE_KEY_FILE=/var/lib/sops-nix/age_key sops /home/mat/nix/secrets.yaml
      '';
    };
  };
in {
  flake.overlays.sopsedit = overlay;
}
