{
  flake.homeModules.userDirs = {config, ...}: let
    dl = "${config.home.homeDirectory}/dl";
  in {
    xdg.enable = true;
    xdg.userDirs = {
      enable = true;
      createDirectories = true;

      desktop = dl;
      documents = dl;
      download = dl;
      music = dl;
      pictures = dl;
      publicShare = dl;
      templates = dl;
      videos = dl;
    };
  };
}
