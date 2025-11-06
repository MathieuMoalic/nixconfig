{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.wireguard;
  types = lib.types;
in {
  options.myModules.wireguard = {
    enable = lib.mkEnableOption "WireGuard VPN server via wg-quick";

    interface = lib.mkOption {
      type = types.str;
      default = "wg0";
    };

    listenPort = lib.mkOption {
      type = types.port;
      default = 51820;
    };

    addresses = lib.mkOption {
      type = types.listOf types.str;
      default = ["10.8.0.1/24"];
    };

    wanInterface = lib.mkOption {
      type = types.str;
      default = "enp1s0";
    };

    enableNat = lib.mkOption {
      type = types.bool;
      default = true;
    };

    # Peers (clients) allowed to connect
    peers = lib.mkOption {
      description = "WireGuard peers (clients).";
      type = types.listOf (types.submodule {
        options = {
          name = lib.mkOption {
            type = types.str;
            default = "peer";
          };
          publicKey = lib.mkOption {
            type = types.str;
          };
          presharedKeyFile = lib.mkOption {
            type = types.nullOr types.path;
            default = null;
          };
          allowedIPs = lib.mkOption {
            type = types.listOf types.str;
            default = [];
          };
          persistentKeepalive = lib.mkOption {
            type = types.nullOr types.ints.unsigned;
            default = 25;
          };
        };
      });
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      secrets."wireguard/privatekey" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };
    };
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
    };

    networking.firewall.allowedUDPPorts = [cfg.listenPort];

    networking.nat = lib.mkIf cfg.enableNat {
      enable = true;
      externalInterface = cfg.wanInterface;
      internalInterfaces = [cfg.interface];
    };

    networking.wg-quick.interfaces."${cfg.interface}" = {
      autostart = true;
      listenPort = cfg.listenPort;
      privateKeyFile = config.sops.secrets."wireguard/privatekey".path;
      address = cfg.addresses;

      peers = map (peer:
        lib.filterAttrs (n: v: v != null && v != []) {
          inherit (peer) publicKey;
          allowedIPs =
            if peer.allowedIPs != []
            then peer.allowedIPs
            else [];
          presharedKeyFile = peer.presharedKeyFile;
          persistentKeepalive = peer.persistentKeepalive;
        })
      cfg.peers;
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/wireguard 0700 root root - -"
    ];
  };
}
