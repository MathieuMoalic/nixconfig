{inputs, ...}: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.nvf.homeManagerModules.default
    inputs.nix-index-database.homeModules.nix-index
  ];
  myModules = {
    xdg.enable = true;
    nix-settings.enable = true;
    session-variables.enable = true;
    color-scheme.enable = true;
  };
  programs.man.enable = false;
  # Make HM auto (re)start changed user units on switch.
  systemd.user.startServices = "sd-switch";
}
