{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.caddy-defaults;
in {
  options.myModules.caddy-defaults = {
    enable = lib.mkEnableOption "Caddy defaults";
  };

  config = lib.mkIf cfg.enable {
    networking = {
      firewall = {
        enable = true;
        allowedTCPPorts = [80 443];
      };
    };
    services.caddy = {
      enable = true;
      virtualHosts = {
        "files.matmoa.eu".extraConfig = ''
          root * /srv/public
          file_server browse
        '';

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
  };
}
