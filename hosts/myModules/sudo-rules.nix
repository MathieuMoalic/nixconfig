{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.sudo-rules;
in {
  options.myModules.sudo-rules = {
    enable = lib.mkEnableOption "sudo-rules";
  };

  config = lib.mkIf cfg.enable {
    security.sudo.extraRules = [
      {
        groups = ["users"];
        commands = [
          {
            command = "/run/wrappers/bin/mount";
            options = ["NOPASSWD"];
          }
          {
            command = "/run/wrappers/bin/umount";
            options = ["NOPASSWD"];
          }
          {
            command = "/run/wrappers/bin/reboot";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}
