{
  pkgs,
  config,
  ...
}: let
  # transmission expects the config.json file to exist
  floodWithConfig = pkgs.symlinkJoin {
    name = "flood-for-transmission-with-config";
    paths = [
      pkgs.flood-for-transmission
      (pkgs.writeTextFile {
        name = "f2t-config-json";
        destination = "/config.json";
        # copy the defaults verbatim so nothing changes, just silence the log
        text = builtins.readFile "${pkgs.flood-for-transmission}/config.json.defaults";
      })
    ];
  };
  user = "media";
  group = "media";
  media_dir = "/media";
  transmission_url = "torrents.matmoa.eu";
in {
  users.groups.${group} = {};
  users.users.${user} = {
    isSystemUser = true;
    inherit group;
  };
  users.users.mat.extraGroups = [group];

  services.caddy = {
    virtualHosts = {
      ${transmission_url} = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:${toString config.services.transmission.settings.rpc-port}
        '';
      };
      # "sonarr2.matmoa.eu" = {
      #   extraConfig = ''
      #     reverse_proxy 127.0.0.1:${toString config.services.sonarr.settings.server.port}
      #   '';
      # };
      # "radarr2.matmoa.eu" = {
      #   extraConfig = ''
      #     reverse_proxy 127.0.0.1:${toString config.services.radarr.settings.server.port}
      #   '';
      # };
      # "prowlarr2.matmoa.eu" = {
      #   extraConfig = ''
      #     reverse_proxy 127.0.0.1:${toString config.services.prowlarr.settings.server.port}
      #   '';
      # };
      # "bazarr2.matmoa.eu" = {
      #   extraConfig = ''
      #     reverse_proxy 127.0.0.1:${toString config.services.bazarr.settings.server.port}
      #   '';
      # };
      # "readarr2.matmoa.eu" = {
      #   extraConfig = ''
      #     reverse_proxy 127.0.0.1:${toString config.services.readarr.settings.server.port}
      #   '';
      # };
      # "flaresolverr.matmoa.eu" = {
      #   extraConfig = ''
      #     reverse_proxy 127.0.0.1:${toString config.services.flaresolverr.port}
      #   '';
      # };
      # "audiobookshelf2.matmoa.eu" = {
      #   extraConfig = ''
      #     reverse_proxy 127.0.0.1:${toString config.services.audiobookshelf.port}
      #   '';
      # };
      # "jellyseerr2.matmoa.eu" = {
      #   extraConfig = ''
      #     reverse_proxy 127.0.0.1:${toString config.services.jellyseerr.port}
      #   '';
      # };
      # "jellyfin2.matmoa.eu" = {
      #   extraConfig = ''
      #     reverse_proxy 127.0.0.1:${toString config.services.jellyfin.port}
      #   '';
      # };
      # "watcharr2.matmoa.eu" = {
      #   extraConfig = ''
      #     reverse_proxy 127.0.0.1:10128
      #   '';
      # };
    };
  };
  services = {
    #   flaresolverr = {
    #     enable = true;
    #     port = 10134;
    #   };
    #   jellyseerr = {
    #     enable = true;
    #     port = 10123;
    #   };
    #   jellyfin = {
    #     enable = true;
    #     inherit user group;
    #     port = 10124;
    #   };
    #   readarr = {
    #     enable = true;
    #     inherit user group;
    #     settings.server = {
    #       port = 10120;
    #     };
    #   };
    #   bazarr = {
    #     enable = true;
    #     inherit user group;
    #     listenPort = 10119;
    #   };
    #   prowlarr = {
    #     enable = true;
    #     inherit user group;
    #     settings.server = {
    #       port = 10116;
    #     };
    #   };
    #   sonarr = {
    #     enable = true;
    #     inherit user group;
    #     settings.server = {
    #       port = 10118;
    #     };
    #   };
    #   radarr = {
    #     enable = true;
    #     inherit user group;
    #     settings.server = {
    #       port = 10117;
    #     };
    #   };
    transmission = {
      enable = true;
      inherit user group;
      # credentialsFile = config.sops.secrets.transmission.path;
      downloadDirPermissions = "755";
      home = "/var/lib/transmission";
      openFirewall = false;
      openRPCPort = true;
      openPeerPorts = false;
      package = pkgs.transmission_4; # default is still v3

      # Whether to enable tweaking of kernel parameters to open many more connections at the same time.
      # Note that you may also want to increase peer-limit-global. And be aware that these settings
      # are quite aggressive and might not suite your regular desktop use.
      # For instance, SSH sessions may time out more easily.
      performanceNetParameters = true;

      webHome = floodWithConfig;
      settings = {
        alt-speed-enabled = false;
        announce-ip-enabled = false;
        blocklist-enabled = false;
        anti-brute-force-enabled = false;
        rpc-host-whitelist = transmission_url;
        rpc-host-whitelist-enabled = true;
        rpc-port = 10122;
        rpc-whitelist = "127.0.0.*,10.10.10.*,100.*.*.*";
        rpc-whitelist-enabled = true;
        start_paused = false;
        cache-size-mb = 4;
        default-trackers = "";
        dht-enabled = true;
        download-dir = "${media_dir}/downloads";
        download-queue-enabled = true;
        download-queue-size = 50;
        encryption = 1;
        idle-seeding-limit-enabled = false;
        incomplete-dir = "${media_dir}/downloads/incomplete";
        lpd-enabled = false;
        message-level = 2;
        peer-congestion-algorithm = "";
        peer-id-ttl-hours = 6;
        peer-limit-global = 200;
        peer-limit-per-torrent = 50;
        peer-port = 51413;
        peer-port-random-high = 65535;
        peer-port-random-low = 49152;
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
        rpc-authentication-required = false;
        rpc-bind-address = "0.0.0.0";
        rpc-enabled = true;
        rpc-password = "{f51355f8fb86f4b7fc899a6efdff3737c50770c32DIFfVf5";
        rpc-socket-mode = "0750";
        rpc-url = "/transmission/";
        rpc-username = "";
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
