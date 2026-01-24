{
  config,
  lib,
  ...
}: let
  cfg = config.myModules.nix-settings;
in {
  options.myModules.nix-settings = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf cfg.enable {
    nix.settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      use-xdg-base-directories = true;
      warn-dirty = false;
    };
  };
}
