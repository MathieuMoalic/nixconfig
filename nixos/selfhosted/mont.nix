{
  flake.nixosModules.mont = {
    config,
    inputs,
    pkgs,
    ...
  }: let
    # Core server configuration
    url = "mont.matmoa.eu";
    port = 10008;
    bindAddr = "127.0.0.1:${toString port}";
    databasePath = "/var/lib/mont/mont.sqlite";
    logFile = "/var/lib/mont/mont.log";
    corsOrigin = "https://${url}";
    syncTime = "05:00";
    gadgetbridgeZip = "/share/gadgetbridge/Gadgetbridge.zip";
    llmApiUrl = "https://openrouter.ai/api/v";
    llmModel = "deepseek/deepseek-v4-flash";
    verbosity = 0;
  in {
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
      "mont/llm-api-key" = {
        owner = "mont";
        group = "mont";
        mode = "0400";
      };
      "mont/usda-api-key" = {
        owner = "mont";
        group = "mont";
        mode = "0400";
      };
    };

    services.mont = {
      # Enable the service
      enable = true;
      package = inputs.mont.packages.${pkgs.stdenv.hostPlatform.system}.prebuilt;

      # Core server configuration
      inherit bindAddr databasePath logFile;
      inherit corsOrigin;

      # Synchronization
      inherit syncTime gadgetbridgeZip;

      # LLM integration
      inherit llmApiUrl llmModel;
      llmApiKeyFile = config.sops.secrets."mont/llm-api-key".path;

      # USDA integration
      usdaApiKeyFile = config.sops.secrets."mont/usda-api-key".path;

      # Authentication
      passwordHashFile = config.sops.secrets."mont/password".path;
      jwtSecretFile = config.sops.secrets."mont/jwt-secret".path;

      # Logging
      inherit verbosity;
    };

    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy ${bindAddr}
    '';
  };
}
