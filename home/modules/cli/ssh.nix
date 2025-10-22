{
  programs.ssh = {
    enable = true;
    serverAliveCountMax = 120;
    serverAliveInterval = 60;
    extraConfig = ''
      StrictHostKeyChecking accept-new
    '';
    matchBlocks = {
      faculty = {
        hostname = "150.254.111.35";
        user = "matmoa";
      };
      pcss = {
        hostname = "eagle.man.poznan.pl";
        user = "mathieum";
      };
      homeserver = {
        hostname = "matmoa.eu";
        user = "mat";
        port = 46464;
      };
      homeserver-initrd = {
        hostname = "matmoa.eu";
        user = "root";
        port = 46466;
      };
      nyx = {
        hostname = "nyx.zfns.eu.org";
        user = "mat";
        port = 46464;
      };
      alecto = {
        hostname = "alecto.zfns.eu.org";
        user = "mat";
        port = 46464;
      };
      zeus = {
        hostname = "zeus.zfns.eu.org";
        user = "mat";
        port = 46464;
      };
      kiosk1 = {
        hostname = "kiosk1.zfns.eu.org";
        user = "root";
      };
      kiosk2 = {
        hostname = "kiosk2.zfns.eu.org";
        user = "root";
      };
    };
  };
}
