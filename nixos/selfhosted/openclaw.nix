{
  flake.nixosModules.openclaw = {
    inputs,
    lib,
    pkgs,
    config,
    ...
  }: let
    url = "claw.matmoa.eu";
    port = 18789;
  in {
    users.users.openclaw = {
      isSystemUser = true;
      group = "openclaw";
      home = "/var/lib/openclaw";
      createHome = true;
      useDefaultShell = true;
    };
    users.groups.openclaw = {};

    sops.secrets."openclaw/env" = {};

    systemd.services.openclaw = {
      description = "OpenClaw Gateway";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      environment = {
        OPENCLAW_HEADLESS = "true";
        OPENCLAW_GATEWAY_HOST = "127.0.0.1";
        OPENCLAW_GATEWAY_PORT = toString port;
        HOME = "/var/lib/openclaw";
      };

      serviceConfig = {
        User = "openclaw";
        Group = "openclaw";
        WorkingDirectory = "/var/lib/openclaw";
        EnvironmentFile = config.sops.secrets."openclaw/env".path;
        ExecStart = "${inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.openclaw}/bin/openclaw gateway run";
        Restart = "on-failure";
        RestartSec = 5;
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = ["/var/lib/openclaw"];
        CapabilityBoundingSet = "";
      };
    };

    services.caddy.virtualHosts.${url}.extraConfig = ''
      import authelia
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
