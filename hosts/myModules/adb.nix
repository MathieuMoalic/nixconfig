{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.adb;
in {
  options.myModules.adb = {
    enable = lib.mkEnableOption "adb";
  };

  config = lib.mkIf cfg.enable {
    users.users.mat.extraGroups = [
      "adbusers"
    ];
    programs = {
      adb.enable = true;
    };
  };
}
