{
  flake.nixosModules.air = {
    config,
    inputs,
    pkgs,
    ...
  }: let
    url = "air.matmoa.eu";
    port = 10025;
    bindAddr = "127.0.0.1:${toString port}";
    metricsUrl = "http://192.168.1.50/metrics";
    databasePath = "/var/lib/air-monitor/air.db";
    pollIntervalMs = 7 * 60 * 1000;
  in {
    services.air = {
      enable = true;
      inherit bindAddr metricsUrl databasePath pollIntervalMs;
    };

    services.caddy.virtualHosts.${url}.extraConfig = ''
      import authelia
      reverse_proxy ${bindAddr}
    '';
  };
}
