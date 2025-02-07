{...}: {
  programs.ssh = {
    enable = true;
    serverAliveCountMax = 120;
    serverAliveInterval = 60;
    extraConfig = "StrictHostKeyChecking accept-new";
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
      homeserver-vscode = {
        hostname = "matmoa.xyz";
        user = "mat";
        port = 46464;
        extraOptions = {
          RemoteCommand = "bash";
        };
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
      vscode-nyx = {
        hostname = "nyx.zfns.eu.org";
        user = "mat";
        port = 46464;
        extraOptions = {
          RemoteCommand = "bash";
        };
      };
      alecto = {
        hostname = "alecto.zfns.eu.org";
        user = "mat";
        port = 46464;
      };
      alecto-vscode = {
        hostname = "alecto.zfns.eu.org";
        user = "mat";
        port = 46464;
        extraOptions = {
          RemoteCommand = "bash";
        };
      };
      zeus = {
        hostname = "zeus.zfns.eu.org";
        user = "mat";
        port = 46464;
      };
      zeus-vscode = {
        hostname = "zeus.zfns.eu.org";
        user = "mat";
        port = 46464;
        extraOptions = {
          RemoteCommand = "bash";
        };
      };
      kiosk1 = {
        hostname = "kiosk1.zfns.eu.org";
        user = "root";
      };
      kiosk2 = {
        hostname = "kiosk2.zfns.eu.org";
        user = "root";
      };
      # These 3 are broken
      # prometheus = {
      #   hostname = "prometheus.zfns.eu.org";
      #   user = "matmoa";
      #   port = 28561;
      # };
      # zephyros = {
      #   hostname = "zephyros.zfns.eu.org";
      #   user = "admin";
      #   port = 23099;
      # };
      # eos = {
      #   hostname = "eos.zfns.eu.org";
      #   user = "matmoa";
      #   port = 4545;
      # };
    };
  };
}
