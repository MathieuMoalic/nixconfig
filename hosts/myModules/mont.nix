{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.myModules.mont;
  types = lib.types;
in {
  options.myModules.mont = {
    enable = lib.mkEnableOption "mont behind Caddy";

    url = lib.mkOption {
      type = types.str;
      default = "mont.matmoa.eu";
      description = "Domain name for the Mont service";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10028;
      description = "Port to bind the backend to (localhost only)";
    };

    logFile = lib.mkOption {
      type = types.str;
      default = "/var/lib/mont/mont.log";
      description = "Path to log file";
    };

    databasePath = lib.mkOption {
      type = types.str;
      default = "/var/lib/mont/mont.sqlite";
      description = "Path to SQLite database";
    };

    gadgetbridgeZip = lib.mkOption {
      type = types.str;
      default = "/var/lib/mont/Gadgetbridge.zip";
      description = "Path to Gadgetbridge.zip";
    };

    verbosity = lib.mkOption {
      type = types.int;
      default = 0;
      description = "Log verbosity (-2 to 3, where 0 is info)";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "mont/password" = {
        owner = "mont";
        group = "mont";
        mode = "0400";
      };
      "mont/jwt-secret" = {
        owner = "mont";
        group = "mont";
        mode = "0400";
      };
    };

    services.mont = {
      enable = true;
      package = inputs.mont.packages.${pkgs.stdenv.hostPlatform.system}.prebuilt;
      bindAddr = "127.0.0.1:${toString cfg.port}";
      corsOrigin = "https://${cfg.url}";
      databasePath = cfg.databasePath;
      gadgetbridgeZip = cfg.gadgetbridgeZip;
      logFile = cfg.logFile;
      verbosity = cfg.verbosity;
      passwordHashFile = config.sops.secrets."mont/password".path;
      jwtSecretFile = config.sops.secrets."mont/jwt-secret".path;
    };

    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
