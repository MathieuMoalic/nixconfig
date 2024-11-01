{...}: {
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
}
