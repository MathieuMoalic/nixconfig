{lib, ...}: let
  dnsList = [
    "9.9.9.9#dns.quad9.net"
    "149.112.112.112#dns.quad9.net"
  ];
in {
  services = {
    resolved = {
      enable = true;
      fallbackDns = dnsList;
      domains = ["~."];
      dnsovertls = "true";
      dnssec = "true";
    };
  };
  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
    networkmanager.dns = "systemd-resolved";
    networkmanager.insertNameservers = dnsList;
    nameservers = dnsList;
    enableIPv6 = true;
  };
}
