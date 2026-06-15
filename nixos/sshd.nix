{
  flake.nixosModules.sshd = {...}: {
    services.openssh = {
      enable = true;
      ports = [46464];
      openFirewall = true;

      allowSFTP = true;
      sftpServerExecutable = "internal-sftp";
      enableRecommendedAlgorithms = true;

      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PubkeyAuthentication = true;
        AuthenticationMethods = "publickey";

        AllowUsers = ["mat"];

        X11Forwarding = false;
        AllowAgentForwarding = false;
        AllowTcpForwarding = "no";
        AllowStreamLocalForwarding = "no";
        PermitTunnel = false;
        GatewayPorts = "no";
        PermitUserEnvironment = false;
        StrictModes = true;
        IgnoreRhosts = true;
        HostbasedAuthentication = false;

        MaxAuthTries = 3;
        MaxSessions = 2;
        LoginGraceTime = "20s";
        LogLevel = "VERBOSE";
        UseDns = false;
      };
    };

    programs.mosh = {
      enable = true;
      openFirewall = true;
      withUtempter = true;
    };
  };
}
