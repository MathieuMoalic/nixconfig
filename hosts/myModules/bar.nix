{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.myModules.bar;
  types = lib.types;
in {
  options.myModules.bar = {
    enable = lib.mkEnableOption "Bar Assistant + Salt Rim via Podman";

    url = lib.mkOption {
      type = types.str;
      default = "bar.matmoa.eu";
    };

    ports = lib.mkOption {
      type = types.submodule {
        options = {
          frontend = lib.mkOption {
            type = types.port;
            default = 10004;
          };
          search = lib.mkOption {
            type = types.port;
            default = 10005;
          };
          backend = lib.mkOption {
            type = types.port;
            default = 10006;
          };
        };
      };
      default = {};
      description = "Host ports for frontend/search/backend.";
    };

    dataDir = lib.mkOption {
      type = types.path;
      default = "/var/lib/bar-assistant";
      description = "Holds Meili data and backend storage.";
    };

    allowRegistration = lib.mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman.enable = true;
    virtualisation.oci-containers.backend = "podman";

    sops.secrets."bar/meili-key" = {
      owner = "root";
      group = "root";
      mode = "0400";
    };
    sops.templates."bar/env" = {
      owner = "root";
      group = "root";
      mode = "0400";
      content = ''
        MEILI_MASTER_KEY=${config.sops.placeholder."bar/meili-key"}
        MEILISEARCH_KEY=${config.sops.placeholder."bar/meili-key"}
      '';
    };

    #### Data dirs ####
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir}               0755 root root - -"
      "d ${cfg.dataDir}/search_data   0755 root root - -"
      "d ${cfg.dataDir}/backend       0755 root root - -"
    ];

    #### Ensure podman network exists ####
    systemd.services.podman-network-bar-proxy = {
      description = "Create podman network bar-proxy";
      serviceConfig.Type = "oneshot";
      wantedBy = ["multi-user.target"];
      script = ''
        set -e
        ${pkgs.podman}/bin/podman network exists bar-proxy \
          || ${pkgs.podman}/bin/podman network create bar-proxy
      '';
    };

    #### Containers ####
    virtualisation.oci-containers.containers = {
      bar-redis = {
        image = "docker.io/redis:6.0.20-alpine3.18";
        autoStart = true;
        environment = {ALLOW_EMPTY_PASSWORD = "yes";};
        extraOptions = ["--network=bar-proxy"];
      };

      bar-search = {
        image = "docker.io/getmeili/meilisearch:v1.12";
        autoStart = true;
        ports = ["${toString cfg.ports.search}:7700"];
        environment = {
          MEILI_ENV = "production";
          MEILI_NO_ANALYTICS = "true";
        };
        environmentFiles = [config.sops.templates."bar/env".path];
        volumes = ["${cfg.dataDir}/search_data:/meili_data"];
        extraOptions = ["--network=bar-proxy"];
      };

      bar-backend = {
        image = "docker.io/barassistant/server:5.1.0";
        autoStart = true;
        ports = ["${toString cfg.ports.backend}:8080"];
        environment = {
          APP_URL = "https://${cfg.url}/bar";
          LOG_CHANNEL = "stderr";
          MEILISEARCH_HOST = "http://bar-search:7700";
          REDIS_HOST = "bar-redis";
          CACHE_DRIVER = "redis";
          SESSION_DRIVER = "redis";
          ALLOW_REGISTRATION = lib.boolToString cfg.allowRegistration;
        };
        environmentFiles = [config.sops.templates."bar/env".path];
        volumes = ["${cfg.dataDir}/backend:/var/www/cocktails/storage/bar-assistant"];
        extraOptions = ["--network=bar-proxy"];
        dependsOn = ["bar-search" "bar-redis"];
      };

      bar-frontend = {
        image = "docker.io/barassistant/salt-rim:4.0.2";
        autoStart = true;
        ports = ["${toString cfg.ports.frontend}:8080"];
        environment = {
          API_URL = "https://${cfg.url}/bar";
          MEILISEARCH_URL = "https://${cfg.url}/search";
        };
        extraOptions = ["--network=bar-proxy"];
        dependsOn = ["bar-backend"];
      };
    };
    systemd.services.podman-bar-redis = {
      # Make sure all containers start after the network unit
      after = ["podman-network-bar-proxy.service"];
      requires = ["podman-network-bar-proxy.service"];
    };
    systemd.services.podman-bar-search = {
      after = ["podman-network-bar-proxy.service"];
      requires = ["podman-network-bar-proxy.service"];
    };
    systemd.services.podman-bar-backend = {
      after = ["podman-network-bar-proxy.service"];
      requires = ["podman-network-bar-proxy.service"];
    };
    systemd.services.podman-bar-frontend = {
      after = ["podman-network-bar-proxy.service"];
      requires = ["podman-network-bar-proxy.service"];
      serviceConfig.ExecStart = lib.mkForce [
        ''          ${pkgs.podman}/bin/podman run --detach --replace \
                --network bar-proxy \
                --restart unless-stopped \
                --name bar-frontend \
                -p 10004:8080 \
                -e API_URL=https://bar.matmoa.eu/bar \
                -e MEILISEARCH_URL=https://bar.matmoa.eu/search \
                --pull=never \
                docker.io/barassistant/salt-rim:4.0.2''
      ];
    };

    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      encode zstd gzip

      handle_path /bar/* {
        reverse_proxy 127.0.0.1:${toString cfg.ports.backend}
      }

      handle_path /search/* {
        reverse_proxy 127.0.0.1:${toString cfg.ports.search}
      }

      handle_path /* {
        reverse_proxy 127.0.0.1:${toString cfg.ports.frontend}
      }
    '';
  };
}
