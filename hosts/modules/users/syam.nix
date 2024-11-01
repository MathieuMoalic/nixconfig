{
  pkgs,
  config,
  ...
}: {
  users.users.syam = {
    isNormalUser = true;
    uid = 1003;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys =
      [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3nskcuXUBuIikiFZ1MT8L+srlSVJnARaLTNdfAGbmZ syam@megaera"
      ]
      ++ config.users.users.mat.openssh.authorizedKeys.keys;
  };
}
