{
  flake.nixosModules.searx = {
    lib,
    pkgs,
    ...
  }: let
    url = "search.matmoa.eu";
    port = 10020;
  in {
    services.searx = {
      enable = true;
      package = pkgs.searxng;
      redisCreateLocally = true;
      environmentFile = "/etc/searx/searx.env";

      settings = {
        general = {
          instance_name = "Private SearXNG";
          debug = false;
          enable_metrics = false;
        };

        server = {
          base_url = "https://${url}/";
          bind_address = "127.0.0.1";
          port = port;
          public_instance = false;
          limiter = false;
          image_proxy = false;
          method = "GET";
        };

        search = {
          safe_search = 0;
          autocomplete = "duckduckgo";
          formats = [
            "html"
            "json"
          ];
        };

        ui = {
          default_theme = "simple";
          theme_args.simple_style = "auto";
        };
      };
    };

    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
