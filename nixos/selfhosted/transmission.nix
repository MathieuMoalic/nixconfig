{
  flake.nixosModules.transmission = {
    lib,
    pkgs,
    config,
    ...
  }: let
    user = "transmission";
    group = "media";
    mediaDir = "/media";
    url = "torrents.matmoa.eu";
    port = 10122;
    floodWithConfig = pkgs.symlinkJoin {
      name = "flood-for-transmission-with-config";
      paths = [
        pkgs.flood-for-transmission
        (pkgs.writeTextFile {
          name = "f2t-config-json";
          destination = "/config.json";
          text = builtins.readFile "${pkgs.flood-for-transmission}/config.json.defaults";
        })
      ];
    };
  in {
    users.groups.${group} = {};
    users.users.${user} = {
      isSystemUser = true;
      group = group;
    };

    sops = {
      secrets."transmission/rpc-password" = {
        owner = user;
        group = group;
        mode = "0400";
      };
      templates."transmission/template" = {
        owner = user;
        group = group;
        mode = "0400";
        content = ''
          {
            "rpc-password": "${config.sops.placeholder."transmission/rpc-password"}"
          }
        '';
      };
    };
    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';

    services.transmission = {
      enable = true;
      user = user;
      group = group;
      credentialsFile = config.sops.templates."transmission/template".path;

      downloadDirPermissions = "755";
      home = "/var/lib/transmission";
      openFirewall = false;
      openRPCPort = true;
      openPeerPorts = false;
      package = pkgs.transmission_4;
      performanceNetParameters = true;

      webHome = floodWithConfig;

      settings = {
        alt-speed-time-enabled = true;
        alt-speed-time-day = 127; # every day
        alt-speed-time-begin = 23 * 60; # 1380 = 23:00
        alt-speed-time-end = 8 * 60; #  480 = 08:00 (wraps over midnight)
        alt-speed-down = 0;
        alt-speed-up = 0;
        alt-speed-enabled = true;

        announce-ip-enabled = false;
        blocklist-enabled = false;
        anti-brute-force-enabled = false;

        rpc-host-whitelist = url;
        rpc-host-whitelist-enabled = true;
        rpc-port = port;
        rpc-whitelist = "127.0.0.*,10.10.10.*,100.*.*.*";
        rpc-whitelist-enabled = false; # todo: remove

        start_paused = false;
        cache-size-mb = 4;
        default-trackers = "";
        dht-enabled = true;
        download-dir = "${mediaDir}/downloads";
        download-queue-enabled = true;
        download-queue-size = 50;
        encryption = 1;
        idle-seeding-limit-enabled = false;
        incomplete-dir = "${mediaDir}/downloads/incomplete";
        lpd-enabled = false;
        message-level = 2;
        peer-congestion-algorithm = "";
        peer-id-ttl-hours = 6;
        peer-limit-global = 200;
        peer-limit-per-torrent = 50;
        peer-port = 51413;
        peer-port-random-on-start = false;
        peer-socket-tos = "le";
        pex-enabled = true;
        port-forwarding-enabled = true;
        preallocation = 1;
        prefetch-enabled = true;
        queue-stalled-enabled = true;
        queue-stalled-minutes = 30;
        ratio-limit-enabled = false;
        rename-partial-files = true;

        rpc-authentication-required = true;
        rpc-bind-address = "0.0.0.0";
        rpc-enabled = true;
        rpc-socket-mode = "0750";
        rpc-url = "/transmission/";
        rpc-username = user;
        # rpc-password is set up using sops templates

        scrape-paused-torrents-enabled = true;
        script-torrent-added-enabled = false;
        seed-queue-enabled = false;
        speed-limit-down-enabled = false;
        speed-limit-up-enabled = false;
        start-added-torrents = true;
        tcp-enabled = true;
        torrent-added-verify-mode = "fast";
        trash-original-torrent-files = false;
        umask = "000";
        upload-slots-per-torrent = 14;
        utp-enabled = false;
        watch-dir-enabled = false;
      };
    };
  };
}
