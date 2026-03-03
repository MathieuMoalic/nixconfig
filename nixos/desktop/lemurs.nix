{
  flake.nixosModules.lemurs = {pkgs, ...}: {
    services.displayManager.lemurs.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-hyprland];
    };
  };
}
