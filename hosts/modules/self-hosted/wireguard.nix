{
  pkgs,
  config,
  ...
}: let
  # wgUiDataDir = "/var/lib/wireguard-ui";
  # address = "wg.matmoa.eu";
  wg_port = 51820;
  # ui_port = 51821;
in {
  # sops.secrets."wireguard/ui-password" = {
  #   owner = "wireguard-ui";
  #   group = "wireguard-ui";
  #   mode = "0400";
  # };
  sops.secrets."wireguard/privatekey" = {
    owner = "root";
    group = "root";
    mode = "0400";
  };

  networking = {
    nat = {
      enable = true;
      externalInterface = "eth0";
      internalInterfaces = ["wg0"];
    };
    firewall = {
      allowedUDPPorts = [wg_port];
    };
  };

  networking.wireguard.interfaces.wg0 = {
    ips = ["10.100.0.1/24"];
    listenPort = wg_port;
    postSetup = ''
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
    '';
    postShutdown = ''
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
    '';
    privateKeyFile = config.sops.secrets."wireguard/privatekey".path;
    peers = [
      # {
      #   # Feel free to give a meaningful name
      #   # Public key of the peer (not a file path).
      #   publicKey = "{client public key}";
      #   allowedIPs = ["10.100.0.2/32"];
      # }
    ];
  };

  # users.users.wireguard-ui = {
  #   isSystemUser = true;
  #   home = wgUiDataDir;
  #   group = "wireguard-ui";
  # };

  # users.groups.wireguard-ui = {};

  # systemd.services.wireguard-ui = {
  #   description = "WireGuard Web UI";
  #   after = ["network.target"];
  #   wantedBy = ["multi-user.target"];

  #   serviceConfig = {
  #     ExecStart = "${pkgs.wireguard-ui}/bin/wireguard-ui";
  #     Restart = "always";
  #     User = "wireguard-ui";
  #     WorkingDirectory = wgUiDataDir;

  #     Environment = [
  #       "BIND_ADDRESS=127.0.0.1:${toString ui_port}"
  #       "WGUI_USERNAME=mat"
  #       "WGUI_CONFIG_FILE_PATH=/etc/wireguard/wg0.conf"
  #       "WGUI_SERVER_INTERFACE_ADDRESSES=10.100.0.1/24"
  #       "WGUI_SERVER_LISTEN_PORT=${toString wg_port}"
  #       "WGUI_ENDPOINT_ADDRESS=${address}:${toString wg_port}" # useful for QR codes
  #       "WGUI_DNS=9.9.9.9"
  #       "WGUI_LOG_LEVEL=INFO"
  #       "WGUI_PASSWORD_FILE=/run/secrets/wireguard-ui/password"
  #     ];
  #   };
  # };

  # systemd.tmpfiles.rules = [
  #   "d ${wgUiDataDir} 0750 wireguard-ui wireguard-ui"
  # ];

  # services.caddy.virtualHosts."${address}" = {
  #   extraConfig = ''
  #     reverse_proxy 127.0.0.1:${toString ui_port}
  #   '';
  # };
}
