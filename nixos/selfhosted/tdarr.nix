{
  flake.nixosModules.tdarr = {
    config,
    lib,
    ...
  }: let
    user = "tdarr";
    group = "media";
    url = "tdarr.matmoa.eu";
    webUIPort = 10034;
    serverPort = 10035;
    dataDir = "/var/lib/tdarr";
  in {
    users.groups.${group} = {};

    sops = {
      secrets = {
        "tdarr/auth-secret-key" = {
          owner = user;
          group = group;
          mode = "0400";
        };
        "tdarr/api-key" = {
          owner = user;
          group = group;
          mode = "0400";
        };
      };

      templates = {
        "tdarr/server-env" = {
          owner = user;
          group = group;
          mode = "0400";
          content = ''
            authSecretKey=${config.sops.placeholder."tdarr/auth-secret-key"}
            seededApiKey=${config.sops.placeholder."tdarr/api-key"}
          '';
        };

        "tdarr/node-env" = {
          owner = user;
          group = group;
          mode = "0400";
          content = ''
            apiKey=${config.sops.placeholder."tdarr/api-key"}
          '';
        };
      };
    };

    services.tdarr = {
      enable = true;
      inherit user group dataDir;

      server = {
        auth.enable = true;
        inherit serverPort webUIPort;
        serverIP = "127.0.0.1";
        serverBindIP = true;
        environmentFile = config.sops.templates."tdarr/server-env".path;
      };

      nodes.main = {
        name = "homeserver";
        type = "mapped";
        environmentFile = config.sops.templates."tdarr/node-env".path;
        workers = {
          transcodeCPU = 2;
          transcodeGPU = 0;
          healthcheckCPU = 1;
          healthcheckGPU = 0;
        };
      };
    };

    # The upstream module hardens the node with ProtectSystem=strict.
    # Allow the local mapped node to write transcoded media on the homeserver mounts.
    systemd.services.tdarr-node-main.serviceConfig.ReadWritePaths = lib.mkAfter [
      "/media"
      "/mnt/ehdd"
    ];

    services.caddy.virtualHosts.${url}.extraConfig = ''
      encode zstd gzip
      reverse_proxy 127.0.0.1:${toString webUIPort}
    '';
  };
}
