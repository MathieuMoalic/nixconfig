{...}: {
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
  in {
    users.groups.${group} = {};
    users.users.${user} = {
      isSystemUser = true;
      group = group;
      extraGroups = ["video" "render"];
    };
    systemd.tmpfiles.rules = [
      "d ${dataDir} 0750 ${user} ${group} - -"
      "d ${dataDir}/model-cache 0750 ${user} ${group} - -"
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
        # host = "127.0.0.1";
        port = 5432;
        user = "immich";
        name = "immich";
        enableVectors = false;
        enableVectorChord = true;
      };

      settings = {
        newVersionCheck.enabled = false;
        server.externalDomain = "https://${url}";
      };

      machine-learning = {
        enable = true;
        environment = {
          CACHE_DIR = "${dataDir}/model-cache";
        };
      };
      openFirewall = false;
    };
    services.postgresql = {
      package = pkgs.postgresql_15.withPackages (ps: [
        ps.pgvector # extension name: "vector"
        ps.vectorchord # extension name: "vchord"
      ]);

      # VectorChord wants to be preloaded
      settings.shared_preload_libraries = "vchord";
    };

    hardware.graphics.enable = true;
    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
