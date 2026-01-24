{
  config,
  lib,
  ...
}: let
  cfg = config.myModules.xdg;
  dl = "${config.home.homeDirectory}/dl";
in {
  options.myModules.xdg = {
    enable = lib.mkEnableOption "redirect all XDG user directories to ~/dl";
  };

  config = lib.mkIf cfg.enable {
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
