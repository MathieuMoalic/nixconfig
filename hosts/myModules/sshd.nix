{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.sshd;
in {
  options.myModules.sshd = {
    enable = lib.mkEnableOption "sshd";
  };

  config = lib.mkIf cfg.enable {
    services = {
      openssh = {
        enable = true;
        ports = [46464];
        openFirewall = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = true;
          GatewayPorts = "yes";
          Subsystem = "sftp internal-sftp"; # for restic
        };
        extraConfig = ''
          Match User cerebre
            ForceCommand internal-sftp
            AllowTcpForwarding no
            X11Forwarding no
            PermitTTY no
          Match all
        '';
      };
    };
    programs.mosh = {
      enable = true;
      openFirewall = true;
      withUtempter = true;
    };
  };
}
