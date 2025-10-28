{...}: {
  services.caddy = {
    enable = true;
    virtualHosts = {
      "photo.matmoa.eu" = {
        extraConfig = ''reverse_proxy localhost:10010'';
      };

      "bar.matmoa.eu" = {
        extraConfig = ''
          handle_path /bar/* {
            reverse_proxy localhost:10006
          }

          handle_path /search/* {
            reverse_proxy localhost:10005
          }

          handle_path /* {
            reverse_proxy localhost:10004
          }
        '';
      };
      "router.matmoa.eu" = {
        extraConfig = ''
          import authelia
          reverse_proxy 192.168.1.1
        '';
      };

      "recipe.matmoa.eu" = {
        extraConfig = ''reverse_proxy localhost:10029'';
      };
    };
  };
}
