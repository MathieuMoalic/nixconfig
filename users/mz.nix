{
  flake.nixosModules.mz = {
    pkgs,
    inputs,
    self,
    config,
    lib,
    ...
  }: {
    programs.zsh.enable = true;

    users = {
      groups.mz.gid = 1001;
      users.mz = {
        isNormalUser = true;
        group = "mz";
        linger = true;
        uid = 1001;
        shell = pkgs.zsh;
        extraGroups = ["networkmanager" "wheel" "video" "input" "uinput"];
        openssh.authorizedKeys.keys =
          [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUUC3kya8Ft2EafiA+4EyivIrOI6X++VkhCig93Yzhq mateusz@Orion"
          ]
          ++ config.users.users.mat.openssh.authorizedKeys.keys;
      };
    };
  };
}
