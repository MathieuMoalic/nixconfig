{...}: {
  flake.nixosModules.prowlarr = {
    lib,
    pkgs,
    config,
    ...
  }: let
    cfg = config.myModules.prowlarr;

    # Turn nested attrset into PROWLARR__SECTION__KEY env vars (Servarr convention)
    mkServarrSettingsEnvVars = prefix: settings:
      lib.pipe settings [
        (lib.mapAttrsRecursive (
          path: value:
            lib.optionalAttrs (value != null) {
              name = lib.toUpper "${prefix}__${lib.concatStringsSep "__" path}";
              value = toString (
                if lib.isBool value
                then lib.boolToString value
                else value
              );
            }
        ))
        (lib.collect (
          x:
            (x ? name) && (x ? value) && lib.isString x.name && lib.isString x.value
        ))
        lib.listToAttrs
      ];
  in {
    options.myModules.prowlarr = {
      enable = lib.mkEnableOption "Prowlarr";

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.prowlarr;
        description = "Prowlarr package to run.";
      };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/prowlarr";
        description = "Prowlarr data directory (passed via -data=...).";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "prowlarr";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "media";
      };

      url = lib.mkOption {
        type = lib.types.str;
        default = "prowlarr.matmoa.eu";
        description = "Hostname for the Caddy virtual host.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 10016;
        description = "HTTP port Prowlarr listens on (behind Caddy).";
      };

      # freeform nested settings mapped to env vars (PROWLARR__...).
      settings = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = {};
        description = "Nested Prowlarr settings mapped to PROWLARR__... env vars.";
      };

      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [];
        description = "Extra EnvironmentFile paths (systemd format).";
      };
    };

    config = lib.mkIf cfg.enable {
      users.groups.${cfg.group} = {};
      users.users.${cfg.user} = {
        isSystemUser = true;
        group = cfg.group;
      };

      # Reasonable defaults when reverse-proxied
      myModules.prowlarr.settings.server.port = lib.mkDefault cfg.port;
      myModules.prowlarr.settings.server.bindAddress = lib.mkDefault "127.0.0.1";

      sops = {
        secrets."prowlarr/apikey" = {
          owner = cfg.user;
          group = cfg.group;
          mode = "0400";
        };

        templates."prowlarr/template" = {
          owner = cfg.user;
          group = cfg.group;
          mode = "0400";
          content = ''
            PROWLARR__AUTH__APIKEY=${config.sops.placeholder."prowlarr/apikey"}
          '';
        };
      };

      systemd.tmpfiles.rules = [
        "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} -"
      ];

      systemd.services.prowlarr = {
        description = "Prowlarr";
        after = ["network.target"];
        wantedBy = ["multi-user.target"];

        environment =
          mkServarrSettingsEnvVars "PROWLARR" cfg.settings
          // {HOME = "/var/empty";};

        serviceConfig = {
          Type = "simple";

          DynamicUser = lib.mkForce false;
          User = cfg.user;
          Group = cfg.group;

          EnvironmentFile =
            [config.sops.templates."prowlarr/template".path]
            ++ cfg.environmentFiles;

          # Don't use lib.getExe here; the binary is capitalized: /bin/Prowlarr
          ExecStart = "${cfg.package}/bin/Prowlarr -nobrowser -data=${cfg.dataDir}";
          Restart = "on-failure";

          UMask = "0002";
          ReadWritePaths = [cfg.dataDir];

          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          NoNewPrivileges = true;
        };
      };

      services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
        encode zstd gzip
        reverse_proxy 127.0.0.1:${toString cfg.port}
      '';
    };
  };
}
