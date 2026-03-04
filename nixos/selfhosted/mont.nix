{
  flake.nixosModules.mont = {
    config,
    inputs,
    pkgs,
    ...
  }: let
    url = "mont.matmoa.eu";
    port = 10008;
    logFile = "/var/lib/mont/mont.log";
    databasePath = "/var/lib/mont/mont.sqlite";
    gadgetbridgePath = "/home/mat/docs/personal/GadgetBridge/Gadgetbridge.zip";
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
    };

    services.mont = {
      inherit gadgetbridgePath databasePath logFile verbosity;
      enable = true;
      package = inputs.mont.packages.${pkgs.stdenv.hostPlatform.system}.prebuilt;
      bindAddr = "127.0.0.1:${toString port}";
      corsOrigin = "https://${url}";
      passwordHashFile = config.sops.secrets."mont/password".path;
      jwtSecretFile = config.sops.secrets."mont/jwt-secret".path;
    };

    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
