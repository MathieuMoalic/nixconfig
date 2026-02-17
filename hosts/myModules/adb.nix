{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.adb;
in {
  options.myModules.adb.enable = lib.mkEnableOption "adb";

  config = lib.mkIf cfg.enable {
    programs.adb.enable = true;
    users.groups.adbusers = {};
    users.users.mat.extraGroups = ["adbusers"];
    services.udev.extraRules = ''
      # OPPO / OnePlus (vendor 22d9) — allow ADB access for adbusers
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="22d9", MODE="0660", GROUP="adbusers"
    '';
  };
}
