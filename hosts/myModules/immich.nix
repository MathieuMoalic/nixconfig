{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.myModules.immich;
  types = lib.types;
in {
  options.myModules.immich = {
    enable = lib.mkEnableOption "immich behind Caddy";

    url = lib.mkOption {
      type = types.str;
      default = "photo.matmoa.eu";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10010;
    };
    user = lib.mkOption {
      type = types.str;
      default = "immich";
    };

    group = lib.mkOption {
      type = types.str;
      default = "immich";
    };
    dataDir = lib.mkOption {
      type = types.path;
      default = "/var/lib/immich";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.${cfg.group} = {};
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      extraGroups = ["video" "render"];
    };
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/model-cache 0750 ${cfg.user} ${cfg.group} - -"
    ];
    sops = {
      secrets."immich/db-password" = {
        owner = cfg.user;
        group = cfg.group;
        mode = "0400";
      };
      templates."immich/template" = {
        owner = cfg.user;
        group = cfg.group;
        mode = "0400";
        content = ''
          DB_PASSWORD=${config.sops.placeholder."immich/db-password"}
        '';
      };
    };
    services.immich = {
      enable = true;

      port = cfg.port;
      host = "127.0.0.1";

      user = cfg.user;
      group = cfg.group;

      mediaLocation = cfg.dataDir;
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
        server.externalDomain = "https://${cfg.url}";
      };

      machine-learning = {
        enable = true;
        environment = {
          CACHE_DIR = "${cfg.dataDir}/model-cache";
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
    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
