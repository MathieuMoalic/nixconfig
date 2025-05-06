{
  pkgs,
  config,
  ...
}: {
  users.users.mz = {
    isNormalUser = true;
    uid = 1001;
    shell = pkgs.zsh;
    initialPassword = "test";
    extraGroups = ["networkmanager" "wheel" "video" "input" "uinput"];
    openssh.authorizedKeys.keys =
      [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUUC3kya8Ft2EafiA+4EyivIrOI6X++VkhCig93Yzhq mateusz@Orion"
      ]
      ++ config.users.users.mat.openssh.authorizedKeys.keys;
  };
}
