{...}: {
  programs.ssh = {
    enable = true;
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
        port = 23232;
      };
      nyx = {
        hostname = "nyx.zfns.eu.org";
        user = "mat";
        port = 46464;
      };
      prometheus = {
        hostname = "prometheus.zfns.eu.org";
        user = "matmoa";
        port = 28561;
      };
      zephyros = {
        hostname = "zephyros.zfns.eu.org";
        user = "admin";
        port = 23099;
      };
    };
  };
}
