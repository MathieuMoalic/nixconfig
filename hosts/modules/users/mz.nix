{
  pkgs,
  config,
  ...
}: {
  users.users.mz = {
    isNormalUser = true;
    uid = 1001;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys =
      [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKJT9ZTSPiYwsVoaSBRTZ6WLVn1wt5FTIwwO6BEcusXa mateusz@DESKTOP-LC7F3KD"
      ]
      ++ config.users.users.mat.openssh.authorizedKeys.keys;
  };
}
