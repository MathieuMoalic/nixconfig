{...}: {
  services.caddy = {
    enable = true;
    configFile = "/mateusz_change_this_caddyfile";
  };

  virtualisation.oci-containers.containers.wg-easy = {
    autoStart = true;
    image = "ghcr.io/wg-easy/wg-easy:14";
    environment = {
      WG_HOST = "vpn2.zfns.eu.org";
      PASSWORD = "your-password"; # Admin password for WG-Easy
    };
    ports = ["51820:51820/udp" "51821:51821/tcp"];
    volumes = [
      "/home/mat/wg-easy:/etc/wireguard:z"
    ];
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--cap-add=SYS_MODULE"
      "--cap-add=NET_RAW"
      "--sysctl=net.ipv4.conf.all.src_valid_mark=1"
      "--sysctl=net.ipv4.ip_forward=1"
    ];
  };
  networking.firewall.allowedUDPPorts = [51820]; # WireGuard port
  networking.firewall.allowedTCPPorts = [51821]; # WG-Easy Web UI
  boot.kernelModules = ["wireguard"];
}
