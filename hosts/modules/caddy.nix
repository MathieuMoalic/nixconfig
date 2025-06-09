{...}: {
  services.caddy = {
    enable = true;
    virtualHosts = {
      "files.matmoa.eu" = {
        extraConfig = ''reverse_proxy localhost:10000'';
      };

      "matrix.matmoa.eu" = {
        extraConfig = ''
          header /.well-known/matrix/* Content-Type application/json
          header /.well-known/matrix/* Access-Control-Allow-Origin *
          respond /.well-known/matrix/server  `{"m.server": "matrix.matmoa.eu:443"}`
          respond /.well-known/matrix/client  `{"m.homeserver":{"base_url":"https://matrix.matmoa.eu"}}`

          reverse_proxy /_matrix/*           localhost:10007
          reverse_proxy /_synapse/client/*   localhost:10007
          reverse_proxy                      localhost:10007
        '';
      };

      "element.matmoa.eu" = {
        extraConfig = ''reverse_proxy localhost:10008'';
      };

      "firefly.matmoa.eu" = {
        extraConfig = ''reverse_proxy localhost:10009'';
      };

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

      "prowlarr.matmoa.eu" = {
        extraConfig = ''reverse_proxy localhost:10016'';
      };

      "radarr.matmoa.eu" = {
        extraConfig = ''reverse_proxy localhost:10017'';
      };

      "sonarr.matmoa.eu" = {
        extraConfig = ''reverse_proxy localhost:10018'';
      };

      "bazarr.matmoa.eu" = {
        extraConfig = ''reverse_proxy localhost:10019'';
      };

      "readarr.matmoa.eu" = {
        extraConfig = ''reverse_proxy localhost:10020'';
      };

      "abs.matmoa.eu" = {
        extraConfig = ''
          encode gzip zstd
          reverse_proxy localhost:10021
        '';
      };

      "trans.matmoa.eu" = {
        extraConfig = ''
          import authelia
          reverse_proxy localhost:10022
        '';
      };

      "jellyseerr.matmoa.eu" = {
        extraConfig = ''reverse_proxy localhost:10023'';
      };

      "jellyfin.matmoa.eu" = {
        extraConfig = ''reverse_proxy localhost:10024'';
      };

      "router.matmoa.eu" = {
        extraConfig = ''
          import authelia
          reverse_proxy 192.168.1.1
        '';
      };

      "watcharr.matmoa.eu" = {
        extraConfig = ''reverse_proxy localhost:10028'';
      };

      "recipe.matmoa.eu" = {
        extraConfig = ''reverse_proxy localhost:10029'';
      };

      "owntracks.matmoa.eu" = {
        extraConfig = ''
          reverse_proxy localhost:10030
          encode gzip zstd
        '';
      };

      "mqtt.matmoa.eu" = {
        extraConfig = ''
          @ws {
            header Connection *Upgrade*
            header Upgrade    websocket
          }

          reverse_proxy @ws localhost:10031 {
            # make sure Caddy speaks HTTP/1.1 to Mosquitto
            transport http {
              versions 1.1
            }
            # pass the upgrade headers through unchanged
            header_up Host       {host}
            header_up Connection {http.request.header.Connection}
            header_up Upgrade    {http.request.header.Upgrade}
          }

          log {
            output file /var/log/caddy/mqtt_ws_access.log
          }
        '';
      };

      "owntracks-frontend.matmoa.eu" = {
        extraConfig = ''
          import authelia
          reverse_proxy localhost:10032
        '';
      };
    };
  };
}
