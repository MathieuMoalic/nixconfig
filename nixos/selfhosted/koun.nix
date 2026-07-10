{
  flake.nixosModules.koun = {
    config,
    inputs,
    pkgs,
    ...
  }: let
    url = "koun.matmoa.eu";
    port = 10009;
    bindAddr = "127.0.0.1:${toString port}";
    databasePath = "/var/lib/koun/koun.sqlite";
    logFile = "/var/lib/koun/koun.log";
    audioDir = "/var/lib/koun/audio";
    corsOrigin = "https://${url}";
  in {
    sops.secrets = {
      "koun/password" = {
        owner = "koun";
        group = "koun";
        mode = "0400";
      };
      "koun/jwt-secret" = {
        owner = "koun";
        group = "koun";
        mode = "0400";
      };
      "koun/llm-api-key" = {
        owner = "koun";
        group = "koun";
        mode = "0400";
      };
      "koun/elevenlabs-api-key" = {
        owner = "koun";
        group = "koun";
        mode = "0400";
      };
    };

    services.koun = {
      enable = true;
      inherit bindAddr databasePath logFile corsOrigin audioDir;
      package = inputs.koun.packages.${pkgs.stdenv.hostPlatform.system}.prebuilt;
      llmApiKeyFile = config.sops.secrets."koun/llm-api-key".path;
      elevenlabsApiKeyFile = config.sops.secrets."koun/elevenlabs-api-key".path;
      passwordHashFile = config.sops.secrets."koun/password".path;
      jwtSecretFile = config.sops.secrets."koun/jwt-secret".path;
    };

    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy ${bindAddr}
    '';
  };
}
