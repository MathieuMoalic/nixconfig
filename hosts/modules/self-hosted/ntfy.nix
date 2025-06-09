{...}: let
  port = 10013;
in {
  services.caddy = {
    virtualHosts = {
      "ntfy.matmoa.eu" = {
        extraConfig = ''reverse_proxy localhost:${toString port}'';
      };
    };
  };
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://ntfy.matmoa.eu";
      listen-http = ":${toString port}";
    };
  };
}
