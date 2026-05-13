{
  flake.homeModules.wayle = {
    config,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      adwaita-icon-theme
    ];

    services.wayle = with config.colorScheme.palette; let
      mkModuleColors = color: {
        border-show = false;
        icon-color = color;
        icon-bg-color = "#${hx-current-line}";
        label-color = color;
        button-bg-color = "#${hx-current-line}";
      };
    in {
      enable = true;

      settings = {
        styling = {
          theme-provider = "wayle";
          scale = 1;
          rounding = "none";

          palette = {
            bg = "#${base00}";
            surface = "#${base00}";
            elevated = "#${hx-current-line}";
            fg = "#${base05}";
            fg-muted = "#${base03}";

            primary = "#${base0D}";
            red = "#${base08}";
            yellow = "#${base0A}";
            green = "#${base0B}";
            blue = "#${base0C}";
          };
        };

        bar = {
          scale = 1;
          location = "top";
          rounding = "none";

          inset-edge = 0.5;
          inset-ends = 0.5;

          padding = 0;
          padding-ends = 0;
          module-gap = 0.5;

          bg = "#${base00}";
          background-opacity = 0;

          border-location = "none";
          border-width = 0;

          shadow = "none";

          button-variant = "basic";
          button-opacity = 100;
          button-bg-opacity = 100;
          button-rounding = "sm";

          # No borders around individual modules.
          button-border-width = 0;

          # Make labels larger relative to icons.
          button-icon-size = 0.85;
          button-label-size = 1.1;
          button-label-weight = "semibold";
          button-icon-padding = 0.8;
          button-label-padding = 0.75;
          button-gap = 1;

          button-group-background = "#${base00}";
          button-group-opacity = 0;
          button-group-border-color = "#${base00}";
          button-group-rounding = "none";
          button-group-module-gap = 0.25;

          dropdown-shadow = false;
          dropdown-opacity = 100;
          dropdown-autohide = true;
          dropdown-freeze-label = true;

          layout = [
            {
              monitor = "*";
              left = ["hyprland-workspaces" "window-title"];
              center = [];
              right = ["network" "volume" "microphone" "clock"];
            }
          ];
        };

        wallpaper = {
          engine-enabled = false;
          cycling-enabled = false;
        };

        osd = {
          enabled = true;
          position = "bottom";
          duration = 2500;
          monitor = "primary";
          border = true;
        };

        modules = {
          clock =
            mkModuleColors "#${base0E}"
            // {
              format = "%Y.%m.%d %H:%M:%S";
              icon-show = true;
              label-show = true;
              dropdown-show-seconds = true;
              right-click = "";
            };

          network =
            mkModuleColors "#${base0D}"
            // {
              icon-show = true;
              label-show = true;
              label-max-length = 15;
            };

          volume =
            mkModuleColors "#${orange}"
            // {
              icon-show = true;
              label-show = true;
              format = "{{ percent }}%";
            };

          microphone =
            mkModuleColors "#${base0B}"
            // {
              icon-show = true;
              label-show = true;
            };

          window-title =
            mkModuleColors "#${base0A}"
            // {
              # Show only the focused app name, not the full window title.
              format = "{{ title }}";

              icon-show = true;
              label-show = true;
              label-max-length = 30;
            };

          hyprland-workspaces = {
            display-mode = "label";
            label-use-name = false;
            numbering = "absolute";
            app-icons-show = false;

            # Show only active/occupied workspaces, not all 10.
            min-workspace-count = 10;

            # Restrict workspaces to the monitor the bar is on.
            monitor-specific = true;

            show-special = true;
            urgent-show = true;
            urgent-mode = "workspace";

            active-indicator = "underline";
            active-color = "#${base0E}";
            occupied-color = "#${orange}";
            empty-color = "#${base0C}";

            container-bg-color = "#${hx-current-line}";
            border-show = false;

            workspace-padding = 0.5;
            label-size = 1.25;
            icon-size = 0.8;
          };

          notification =
            mkModuleColors "#${base0D}"
            // {
              popup-position = "top-right";
              popup-shadow = false;
              popup-urgency-bar = "low";
              icon-source = "automatic";
            };
        };
      };
    };
  };
}
