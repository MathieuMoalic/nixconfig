{...}: {
  flake.nixosModules.prowlarr = {
    lib,
    pkgs,
    config,
    ...
  }: let
    user = "prowlarr";
    group = "media";
    url = "prowlarr.matmoa.eu";
    port = 10016;
    dataDir = "/var/lib/prowlarr";
  in {
    users.groups.${group} = {};
    users.users.${user} = {
      isSystemUser = true;
      group = group;
    };

    sops = {
      secrets."prowlarr/apikey" = {
        owner = user;
        group = group;
        mode = "0400";
      };
      templates."prowlarr/template" = {
        owner = user;
        group = group;
        mode = "0400";
        content = ''
          PROWLARR__AUTH__APIKEY=${config.sops.placeholder."prowlarr/apikey"}
        '';
      };
    };

    systemd.tmpfiles.rules = [
      "d ${dataDir} 0750 ${user} ${group} -"
    ];

    systemd.services.prowlarr = {
      description = "Prowlarr";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      environment = {
        PROWLARR__SERVER__PORT = toString port;
        PROWLARR__SERVER__BINDADDRESS = "127.0.0.1";
        HOME = "/var/empty";
      };
      serviceConfig = {
        Type = "simple";
        User = user;
        Group = group;
        EnvironmentFile = [config.sops.templates."prowlarr/template".path];
        ExecStart = "${pkgs.prowlarr}/bin/Prowlarr -nobrowser -data=${dataDir}";
        Restart = "on-failure";
        UMask = "0002";
        ReadWritePaths = [dataDir];
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
    };

    services.caddy.virtualHosts.${url}.extraConfig = ''
      encode zstd gzip
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
