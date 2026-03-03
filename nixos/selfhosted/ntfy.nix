{...}: {
  flake.nixosModules.ntfy = {
    lib,
    config,
    ...
  }: let
    url = "ntfy.matmoa.eu";
    port = 10013;
  in {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://ntfy.matmoa.eu";
        listen-http = ":${toString port}";
      };
    };
    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
