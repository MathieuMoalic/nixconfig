{
  flake.nixosModules.dns = let
    dnsList = [
      "9.9.9.9#dns.quad9.net"
      "149.112.112.112#dns.quad9.net"
    ];
  in
    {lib, ...}: {
      services.resolved = {
        enable = true;

        settings.Resolve = {
          DNS = dnsList;
          FallbackDNS = dnsList;
          Domains = ["~."];
          DNSOverTLS = "true";
          DNSSEC = "true";
        };
      };

      networking = {
        useDHCP = lib.mkDefault true;

        networkmanager = {
          enable = true;
          dns = "systemd-resolved";
          insertNameservers = dnsList;
        };

        nameservers = dnsList;
        enableIPv6 = true;
      };
    };
}
