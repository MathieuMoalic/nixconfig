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
      };
    };
  };
}
