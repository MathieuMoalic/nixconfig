{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.myModules.lemurs;
in {
  options.myModules.lemurs = {
    enable = lib.mkEnableOption "lemurs";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.lemurs = {
      enable = true;
    };

    users.users.mat.extraGroups = ["seat"];

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-hyprland];
  };
}
