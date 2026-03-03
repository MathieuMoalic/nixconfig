{
  flake.nixosModules.lemurs = {
    lib,
    pkgs,
    config,
    ...
  }: {
    services.displayManager.lemurs.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-hyprland];
    };
  };
}
