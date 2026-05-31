{
  flake.homeModules.ssh = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "*" = {
          StrictHostKeyChecking = "accept-new";
          ForwardAgent = false;
          ServerAliveInterval = 300;
        };

        faculty = {
          HostName = "150.254.111.35";
          User = "matmoa";
        };

        pcss = {
          HostName = "eagle.man.poznan.pl";
          User = "mathieum";
        };

        zagreus = {
          HostName = "192.168.1.81";
          User = "mat";
          Port = 46464;
        };

        homeserver = {
          HostName = "matmoa.eu";
          User = "mat";
          Port = 46464;
        };

        homeserver-initrd = {
          HostName = "matmoa.eu";
          User = "root";
          Port = 46466;
        };

        nyx = {
          HostName = "nyx.zfns.eu.org";
          User = "mat";
          Port = 46464;
        };

        alecto = {
          HostName = "alecto.zfns.eu.org";
          User = "mat";
          Port = 46464;
        };

        zeus = {
          HostName = "zeus.zfns.eu.org";
          User = "mat";
          Port = 46464;
        };

        kiosk1 = {
          HostName = "kiosk1.zfns.eu.org";
          User = "root";
        };

        kiosk2 = {
          HostName = "kiosk2.zfns.eu.org";
          User = "root";
        };
      };
    };
  };
}
