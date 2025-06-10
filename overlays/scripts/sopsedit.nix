{pkgs, ...}:
pkgs.writeShellApplication {
  name = "sopsedit";
  runtimeInputs = with pkgs; [sops];
  text = ''
    SOPS_AGE_KEY_FILE=/home/mat/.ssh/age_key sops /home/mat/nix/secrets.yaml
  '';
}
