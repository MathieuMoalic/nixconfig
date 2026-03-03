{
  flake.nixosModules.blaz = {
    config,
    pkgs,
    inputs,
    ...
  }: let
    url = "blaz.matmoa.eu";
    port = 10024;

    logFile = "/var/lib/blaz/blaz.log";
    databasePath = "/var/lib/blaz/blaz.sqlite";
    mediaDir = "/var/lib/blaz/media";

    verbosity = 0;

    llmModel = "deepseek/deepseek-chat";
    llmApiUrl = "https://openrouter.ai/api/v1";
    systemPromptImport = null;
    systemPromptMacros = null;

    s = config.sops.secrets;
    passwordHashFile = s."blaz/password".path;
    jwtSecretFile = s."blaz/jwt-secret".path;
    llmApiKeyFile = s."blaz/llm-api-key".path;
  in {
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

    services.blaz = {
      enable = true;
      package = inputs.blaz.packages.${pkgs.stdenv.hostPlatform.system}.prebuilt;
      bindAddr = "127.0.0.1:${toString port}";
      corsOrigin = "https://${url}";

      inherit
        databasePath
        mediaDir
        logFile
        verbosity
        llmModel
        llmApiUrl
        systemPromptImport
        systemPromptMacros
        passwordHashFile
        jwtSecretFile
        llmApiKeyFile
        ;
    };

    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
