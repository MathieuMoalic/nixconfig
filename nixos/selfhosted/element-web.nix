{...}: {
  flake.nixosModules.element-web = {
    lib,
    pkgs,
    config,
    ...
  }: let
    cfg = config.myModules.element-web;

    json = pkgs.formats.json {};
    elementConfigFile = json.generate "config.json" cfg.config;

    elementWebWithConfig =
      pkgs.runCommand
      "element-web-${lib.getVersion cfg.package}-with-config"
      {}
      ''
        set -eu
        mkdir -p "$out"
        cp -r --no-preserve=mode,ownership ${cfg.package}/* "$out"/
        chmod -R u+w "$out"
        cp ${elementConfigFile} "$out/config.json"
        sha256sum "$out/config.json" > "$out/.config-hash"
      '';
  in {
    options.myModules.element-web = {
      enable = lib.mkEnableOption "Serve Element Web (static) via Caddy";

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.element-web;
      };

      # If you actually want https on 443, set port = 443 and (optionally) listenAddresses = [].
      port = lib.mkOption {
        type = lib.types.port;
        default = 10008;
      };

      url = lib.mkOption {
        type = lib.types.str;
        default = "element.matmoa.eu";
      };

      # Bind only on localhost by default (you can override to [] to bind everywhere)
      listenAddresses = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["127.0.0.1" "::1"];
      };

      # Element config.json
      config = lib.mkOption {
        type = json.type;
        default = {
          default_server_config = {
            "m.homeserver" = {
              base_url = "https://matrix.matmoa.eu";
              server_name = "matmoa";
            };
            "m.identity_server" = {
              base_url = "https://vector.im";
            };
          };

          disable_custom_urls = false;
          disable_guests = false;
          disable_login_language_selector = false;
          disable_3pid_login = false;

          brand = "Element";

          integrations_ui_url = "https://scalar.vector.im/";
          integrations_rest_url = "https://scalar.vector.im/api";
          integrations_widgets_urls = [
            "https://scalar.vector.im/_matrix/integrations/v1"
            "https://scalar.vector.im/api"
            "https://scalar-staging.vector.im/_matrix/integrations/v1"
            "https://scalar-staging.vector.im/api"
            "https://scalar-staging.riot.im/scalar/api"
          ];

          bug_report_endpoint_url = "https://element.io/bugreports/submit";
          uisi_autorageshake_app = "element-auto-uisi";
          default_country_code = "FR";
          show_labs_settings = true;
          features = {};
          default_federate = true;
          default_theme = "dark";

          room_directory.servers = ["matrix.org"];

          enable_presence_by_hs_url = {
            "https://matrix.org" = false;
            "https://matrix-client.matrix.org" = false;
          };

          setting_defaults.breadcrumbs = true;

          jitsi.preferred_domain = "meet.element.io";

          element_call.url = "https://call.element.io";

          map_style_url = "https://api.maptiler.com/maps/streets/style.json?key=fU3vlMsMn4Jb6dnEIFsx";
        };
      };
    };

    config = lib.mkIf cfg.enable {
      services.caddy.virtualHosts."http://${cfg.url}:${toString cfg.port}" = {
        listenAddresses = cfg.listenAddresses;
        extraConfig = ''
          root * ${elementWebWithConfig}
          encode zstd gzip

          @configjson path /config.json
          header @configjson Cache-Control "no-cache"

          file_server
        '';
      };
    };
  };
}
