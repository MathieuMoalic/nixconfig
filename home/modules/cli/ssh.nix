{
  programs.ssh = {
    enable = true;
    serverAliveCountMax = 120;
    serverAliveInterval = 60;
    extraConfig = ''
      StrictHostKeyChecking accept-new
      Include ~/.ssh/config2
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
        hostname = "matmoa.xyz";
        user = "mat";
        port = 46464;
      };
      homeserver-initrd = {
        hostname = "matmoa.xyz";
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

  home.file.".ssh/config2" = {
    text = ''
      Host homeserver
        HostName matmoa.xyz
        User mat
        Port 46464
        RemoteCommand bash

      Host nyx
        HostName nyx.zfns.eu.org
        User mat
        Port 46464
        RemoteCommand bash

      Host alecto
        HostName alecto.zfns.eu.org
        User mat
        Port 46464
        RemoteCommand bash

      Host zeus
        HostName zeus.zfns.eu.org
        User mat
        Port 46464
        RemoteCommand bash
    '';
  };
}
