{
  flake.nixosModules.immich = {
    lib,
    pkgs,
    config,
    ...
  }: let
    url = "photo.matmoa.eu";
    port = 10010;
    user = "immich";
    group = "immich";
    dataDir = "/var/lib/immich";
    hddDir = "/media/immich";
  in {
    users.groups.${group} = {};
    users.users.${user} = {
      isSystemUser = true;
      group = group;
      extraGroups = ["video" "render"];
    };
    systemd.tmpfiles.rules = [
      "d ${dataDir} 0750 ${user} ${group} - -"

      "d ${hddDir} 0750 ${user} ${group} - -"
      "d ${hddDir}/library 0750 ${user} ${group} - -"
      "d ${hddDir}/upload 0750 ${user} ${group} - -"
      "d ${hddDir}/encoded-video 0750 ${user} ${group} - -"
      "d ${hddDir}/backups 0750 ${user} ${group} - -"

      # Mountpoints for bind mounts.
      "d ${dataDir}/library 0750 ${user} ${group} - -"
      "d ${dataDir}/upload 0750 ${user} ${group} - -"
      "d ${dataDir}/encoded-video 0750 ${user} ${group} - -"
      "d ${dataDir}/backups 0750 ${user} ${group} - -"
    ];
    fileSystems = {
      "${dataDir}/library" = {
        depends = [hddDir];
        device = "${hddDir}/library";
        fsType = "none";
        options = ["bind"];
      };

      "${dataDir}/upload" = {
        depends = [hddDir];
        device = "${hddDir}/upload";
        fsType = "none";
        options = ["bind"];
      };

      "${dataDir}/encoded-video" = {
        depends = [hddDir];
        device = "${hddDir}/encoded-video";
        fsType = "none";
        options = ["bind"];
      };

      "${dataDir}/backups" = {
        depends = [hddDir];
        device = "${hddDir}/backups";
        fsType = "none";
        options = ["bind"];
      };
    };

    systemd.services.immich-server.unitConfig.RequiresMountsFor = [
      "${dataDir}/library"
      "${dataDir}/upload"
      "${dataDir}/encoded-video"
      "${dataDir}/backups"
    ];

    sops = {
      secrets."immich/db-password" = {
        owner = user;
        group = group;
        mode = "0400";
      };
      templates."immich/template" = {
        owner = user;
        group = group;
        mode = "0400";
        content = ''
          DB_PASSWORD=${config.sops.placeholder."immich/db-password"}
        '';
      };
    };
    services.immich = {
      enable = true;

      port = port;
      host = "127.0.0.1";

      user = user;
      group = group;

      mediaLocation = dataDir;

      accelerationDevices = ["/dev/dri"];
      secretsFile = config.sops.templates."immich/template".path;

      environment = {
        DB_USERNAME = "immich";
        DB_DATABASE_NAME = "immich";
      };

      redis = {
        enable = true;
        host = "127.0.0.1";
        port = 6379;
      };

      database = {
        enable = true;
        createDB = true;
        port = 5432;
        user = "immich";
        name = "immich";
      };

      settings = {
        newVersionCheck.enabled = false;
        server.externalDomain = "https://${url}";
      };

      machine-learning = {
        enable = true;
      };

      openFirewall = false;
    };

    services.postgresql = {
      package = pkgs.postgresql_15.withPackages (ps: [
        ps.pgvector
        ps.vectorchord
      ]);

      settings.shared_preload_libraries = "vchord";
    };

    hardware.graphics.enable = true;

    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
