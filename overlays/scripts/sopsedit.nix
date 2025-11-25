{pkgs, ...}:
pkgs.writeShellApplication {
  name = "sopsedit";
  runtimeInputs = with pkgs; [sops];
  text = ''
    sudo SOPS_AGE_KEY_FILE=/var/lib/sops-nix/age_key sops /home/mat/nix/secrets.yaml
  '';
}
