{lib, ...}: {
  # services = {
  #   resolved = {
  #     enable = true;
  #     fallbackDns = [
  #       "1.1.1.1#cloudflare-dns.com"
  #       "8.8.8.8#dns.google"
  #     ];
  #     domains = ["~."];
  #     dnsovertls = "true";
  #     dnssec = "true";
  #   };
  # };
  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
    # networkmanager.dns = "systemd-resolved";
    # nameservers = ["9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net"];
    # enableIPv6 = true;
  };
  environment.etc."resolv.conf".text = ''
    nameserver 9.9.9.9
    nameserver 149.112.112.112
  '';
}
