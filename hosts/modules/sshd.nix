{...}: {
  services = {
    openssh = {
      enable = true;
      ports = [46464];
      openFirewall = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
        GatewayPorts = "yes";
      };
    };
  };
  programs.mosh = {
    enable = true;
    openFirewall = true;
    withUtempter = true;
  };
}
