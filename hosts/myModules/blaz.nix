{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.blaz;
  types = lib.types;
in {
  options.myModules.blaz = {
    enable = lib.mkEnableOption "blaz behind Caddy";

    url = lib.mkOption {
      type = types.str;
      default = "blaz.matmoa.eu";
      description = "Domain name for the Blaz service";
    };

    port = lib.mkOption {
      type = types.port;
      default = 10024;
      description = "Port to bind the backend to (localhost only)";
    };

    # Basic options
    logFile = lib.mkOption {
      type = types.str;
      default = "/var/lib/blaz/blaz.log";
      description = "Path to log file";
    };

    databasePath = lib.mkOption {
      type = types.str;
      default = "/var/lib/blaz/blaz.sqlite";
      description = "Path to SQLite database";
    };

    mediaDir = lib.mkOption {
      type = types.str;
      default = "/var/lib/blaz/media";
      description = "Directory for media files";
    };

    verbosity = lib.mkOption {
      type = types.int;
      default = 0;
      description = "Log verbosity (-2 to 3, where 0 is info)";
    };

    # LLM options
    llmModel = lib.mkOption {
      type = types.str;
      default = "deepseek/deepseek-chat";
      description = "LLM model to use";
    };

    llmApiUrl = lib.mkOption {
      type = types.str;
      default = "https://openrouter.ai/api/v1";
      description = "LLM API endpoint URL";
    };

    systemPromptImport = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Custom system prompt for recipe import";
    };

    systemPromptMacros = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Custom system prompt for macro estimation";
    };
  };

  config = lib.mkIf cfg.enable {
    # Define sops secrets
    sops.secrets = {
      "blaz/password" = {
        owner = "blaz";
        group = "blaz";
        mode = "0400";
      };
      "blaz/jwt-secret" = {
        owner = "blaz";
        group = "blaz";
        mode = "0400";
      };
      "blaz/llm-api-key" = {
        owner = "blaz";
        group = "blaz";
        mode = "0400";
      };
    };

    # Configure Blaz service
    services.blaz = {
      enable = true;

      # Network configuration
      bindAddr = "127.0.0.1:${toString cfg.port}";
      corsOrigin = "https://${cfg.url}";

      # Paths
      databasePath = cfg.databasePath;
      mediaDir = cfg.mediaDir;
      logFile = cfg.logFile;

      # Logging
      verbosity = cfg.verbosity;

      # Secrets from sops
      passwordHashFile = config.sops.secrets."blaz/password".path;
      jwtSecretFile = config.sops.secrets."blaz/jwt-secret".path;
      llmApiKeyFile = config.sops.secrets."blaz/llm-api-key".path;

      # LLM configuration
      llmModel = cfg.llmModel;
      llmApiUrl = cfg.llmApiUrl;
      systemPromptImport = cfg.systemPromptImport;
      systemPromptMacros = cfg.systemPromptMacros;
    };

    # Caddy reverse proxy
    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
