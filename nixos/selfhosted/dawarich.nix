{
  flake.nixosModules.dawarich = {
    pkgs,
    lib,
    config,
    ...
  }: let
    user = "dawarich";
    group = "dawarich";
    url = "dawarich.matmoa.eu";
    port = 10005;
  in {
    sops = {
      secrets."dawarich/secret-key-base" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };

      templates."dawarich/environment" = {
        owner = user;
        group = group;
        mode = "0400";
        content = ''
          RAILS_LOG_TO_STDOUT=1
        '';
      };
    };

    services.dawarich = {
      enable = true;
      package = pkgs.dawarich;

      user = user;
      group = group;

      localDomain = url;
      webPort = port;

      configureNginx = false;
      automaticMigrations = true;

      secretKeyBaseFile = config.sops.secrets."dawarich/secret-key-base".path;
      extraEnvFiles = [config.sops.templates."dawarich/environment".path];

      database = {
        createLocally = true;
        name = "dawarich";
        user = "dawarich";
      };

      redis = {
        createLocally = true;
      };

      sidekiqThreads = 5;
      sidekiqProcesses = {
        default = {
          threads = 5;
          jobClasses = [];
        };
      };

      environment = {
        RAILS_ENV = "production";
      };
    };

    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
