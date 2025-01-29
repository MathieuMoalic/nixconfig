{pkgs, ...}: {
  users = {
    groups = {
      mat = {
        gid = 1000;
      };
    };
    mutableUsers = false;
    users = {
      mat = {
        isNormalUser = true;
        group = "mat";
        linger = true;
        uid = 1000;
        extraGroups = ["networkmanager" "wheel" "video" "input" "uinput"];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPcmHHg1pEOAxvEAyr6p5MY0m3/+BOn8nJOcAf7mMaej"
        ];
        hashedPassword = "$6$4lSS.DgMsihs04VX$uu3991ckntJRdsu/Mo7nYuo06M7s9zXDRT7l110LUjPN4lq1OtUNC1ER/WEaLXCSNBxIiZfMWKc0jdBN.xRs1.";
        shell = pkgs.nushell;
      };
      root = {
        hashedPassword = "$6$4lSS.DgMsihs04VX$uu3991ckntJRdsu/Mo7nYuo06M7s9zXDRT7l110LUjPN4lq1OtUNC1ER/WEaLXCSNBxIiZfMWKc0jdBN.xRs1.";
      };
    };
  };
}
