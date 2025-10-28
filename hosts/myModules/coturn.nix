{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.coturn;
in {
  options.myModules.coturn = {
    enable = lib.mkEnableOption "Enable the matmoa.eu coturn preset";

    user = lib.mkOption {
      type = lib.types.str;
      default = "turnserver";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "turnserver";
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      secrets."coturn/secret" = {
        owner = cfg.user;
        group = cfg.group;
        mode = "0400";
      };
    };
    services.coturn = {
      enable = true;

      lt-cred-mech = true;
      use-auth-secret = true;
      static-auth-secret-file = config.sops.templates."coturn/secret".path;
      realm = "matmoa.eu";
      min-port = 49160;
      max-port = 49200;
      # UDP 3478 (best quality/latency) and TCP 3478 (fallback) and port 5349 for locked-down networks.
      extraConfig = ''
        syslog
        verbose
        external-ip=109.173.160.203
      '';
    };
  };
}
