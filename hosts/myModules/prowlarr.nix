{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.myModules.prowlarr;
  types = lib.types;

  mkServarrSettingsEnvVars = name: settings:
    lib.pipe settings [
      (lib.mapAttrsRecursive (
        path: value:
          lib.optionalAttrs (value != null) {
            name = lib.toUpper "${name}__${lib.concatStringsSep "__" path}";
            value = toString (
              if lib.isBool value
              then lib.boolToString value
              else value
            );
          }
      ))
      (lib.collect (x: lib.isString x.name or false && lib.isString x.value or false))
      lib.listToAttrs
    ];
in {
  options.myModules.prowlarr = {
    enable = lib.mkEnableOption "Prowlarr (indexer manager)";

    package = lib.mkPackageOption pkgs "prowlarr" {};

    dataDir = lib.mkOption {
      type = types.path;
      default = "/var/lib/prowlarr";
      description = "Persistent state directory passed as -data.";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = (pkgs.formats.ini {}).type;
        options = {};
      };
      default = {};
    };

    # inline of mkServarrEnvironmentFiles "prowlarr"
    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [];
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "prowlarr";
      description = "User account to run Prowlarr under.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "media";
      description = "Primary group for the Prowlarr user.";
    };

    url = lib.mkOption {
      type = types.str;
      default = "prowlarr.matmoa.eu";
      description = "Hostname served by Caddy.";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10016;
      description = "Prowlarr port.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.${cfg.group} = {};
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
    };

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
          PROWLARR__AUTH__APIKEY="${config.sops.placeholder."prowlarr/apikey"}"
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

      # turn settings attrset into PROWLARR__... env vars (per Servarr convention)
      environment =
        mkServarrSettingsEnvVars "PROWLARR" cfg.settings
        // {
          HOME = "/var/empty";
        };

      serviceConfig = {
        Type = "simple";
        DynamicUser = lib.mkForce false;
        User = cfg.user;
        Group = cfg.group;

        EnvironmentFile = [config.sops.templates."prowlarr/template".path] ++ cfg.environmentFiles;
        ExecStart = "${lib.getExe cfg.package} -nobrowser -data=${cfg.dataDir}";
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
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';

    myModules.prowlarr.settings.server.port = lib.mkDefault cfg.port;
  };
}
