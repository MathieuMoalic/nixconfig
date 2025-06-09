# Doesn't work
{
  pkgs,
  config,
  ...
}: let
  wg_port = 51820;
in {
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
      {
        # zagreus
        publicKey = "ckEGrsAEpqbf+leE0a9ua/4MtU8MxTCnP5h02dx8dEo=";
        allowedIPs = ["10.100.0.2/32"];
      }
    ];
  };
}
