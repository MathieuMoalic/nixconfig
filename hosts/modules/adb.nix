{...}: {
  users.users.mat.extraGroups = [
    "adbusers"
  ];
  programs = {
    adb.enable = true;
  };
}
