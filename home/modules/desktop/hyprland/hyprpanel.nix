{
  osConfig,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    adwaita-icon-theme
  ];
  programs.hyprpanel = {
    enable = true;
    systemd.enable = true;

    settings = let
      rightModules =
        if osConfig.networking.hostName == "xps"
        then ["network" "volume" "microphone" "bluetooth" "battery" "clock"]
        else ["network" "volume" "microphone" "clock"];

      commonBarLayout = {
        left = ["workspaces" "windowtitle"];
        middle = ["media"];
        right = rightModules;
      };
    in {
      bar = {
        layouts = {
          "0" = commonBarLayout;
          "1" = commonBarLayout;
          "2" = commonBarLayout;
        };
        autoHide = "fullscreen";
        clock = {
          format = "%Y.%m.%d %H:%M:%S";
        };
      };
      menus = {
        clock = {
          time = {
            military = true;
          };
          weather.enabled = false;
        };
      };

      hyprpanel = {
        restartAgs = true;
        restartCommand = "${pkgs.hyprpanel}/bin/hyprpanel q; ${pkgs.hyprpanel}/bin/hyprpanel";
      };
      scalingPriority = "gdk";
      tear = false;
      terminal = "$TERM";
      dummy = true;
      wallpaper.enable = false;
      theme = {
        bar = {
          border_radius = "0.4em";
          dropdownGap = "2.9em";
          enableShadow = false;
          floating = false;
          label_spacing = "0.5em";
          layer = "top";
          location = "top";
          margin_bottom = "0em";
          margin_sides = "0.5em";
          margin_top = "0.5em";
          opacity = 0;
          outer_spacing = "0em";
          scaling = 100;
          shadow = "0px 1px 2px 1px #16161e";
          shadowMargins = "0px 0px 4px 0px";
          transparent = false;
          menus = {
            tooltip = {
              text = "#f8f8f2";
              background = "#282a36";
            };
            dropdownmenu = {
              divider = "#44475a";
              text = "#f8f8f2";
              background = "#282a36";
            };
            slider = {
              puck = "#44475a";
              backgroundhover = "#44475a";
              background = "#44475a";
              primary = "#bd93f9";
            };
            progressbar = {
              background = "#44475a";
              foreground = "#bd93f9";
            };
            iconbuttons = {
              active = "#bd93f9";
              passive = "#f8f8f2";
            };
            buttons = {
              text = "#282a36";
              disabled = "#44475a";
              active = "#ff79c6";
              default = "#bd93f9";
            };
            check_radio_button = {
              active = "#bd93f9";
              background = "#282936";
            };
            switch = {
              puck = "#44475a";
              disabled = "#44475a";
              enabled = "#bd93f9";
            };
            icons = {
              active = "#bd93f9";
              passive = "#44475a";
            };
            listitems = {
              active = "#bd93f9";
              passive = "#f8f8f2";
            };
            popover = {
              border = "#282a36";
              background = "#282a36";
              text = "#bd93f9";
            };
            label = "#bd93f9";
            feinttext = "#44475a";
            dimtext = "#6272a4";
            text = "#f8f8f2";
            border.color = "#44475a";
            cards = "#44475a";
            background = "#6272a4";
            menu = {
              network = {
                switch = {
                  enabled = "#bd93f9";
                  disabled = "#44475a";
                  puck = "#44475a";
                };
                scroller.color = "#bd93f9";
              };
              media.timestamp = "#f8f8f2";
              bluetooth.scroller.color = "#8be9fd";
            };
          };
          buttons = {
            clock = {
              icon = "#ff79c6";
              text = "#ff79c6";
              background = "#44475a";
              border = "#ff79c6";
            };
            battery = {
              icon_background = "#f1fa8c";
              icon = "#f1fa8c";
              text = "#f1fa8c";
              background = "#44475a";
              border = "#f1fa8c";
            };
            bluetooth = {
              icon_background = "#89dbeb";
              icon = "#8be9fd";
              text = "#8be9fd";
              background = "#44475a";
              border = "#8be9fd";
            };
            network = {
              icon_background = "#caa6f7";
              icon = "#bd93f9";
              text = "#bd93f9";
              background = "#44475a";
              border = "#bd93f9";
            };
            volume = {
              icon_background = "#ffb86c";
              icon = "#ffb86c";
              text = "#ffb86c";
              background = "#44475a";
              border = "#ffb86c";
            };
            media = {
              icon_background = "#bd93f9";
              icon = "#bd93f9";
              text = "#bd93f9";
              background = "#44475a";
              border = "#bd93f9";
            };
            windowtitle = {
              icon_background = "#ff79c6";
              icon = "#f1fa8c";
              text = "#f1fa8c";
              border = "#f1fa8c";
              background = "#44475a";
            };
            workspaces = {
              numbered_active_underline_color = "#e23ee2";
              numbered_active_highlighted_text_color = "#21252b";
              hover = "#44475a";
              active = "#ff79c6";
              occupied = "#ffb86c";
              available = "#8be9fd";
              border = "#44475a";
              background = "#44475a";
            };
            icon = "#bd93f9";
            text = "#bd93f9";
            hover = "#44475a";
            icon_background = "#44475a";
            background = "#282936";
            style = "default";
            modules = {
              microphone = {
                border = "#50fa7b";
                background = "#44475a";
                text = "#50fa7b";
                icon = "#50fa7b";
                icon_background = "#44475a";
              };
            };
            borderColor = "#bd93f9";
          };
          background = "#282a36";
          border.color = "#bd93f9";
        };
        osd = {
          label = "#bd93f9";
          icon = "#282a36";
          bar_overflow_color = "#ff5555";
          bar_empty_color = "#44475a";
          bar_color = "#bd93f9";
          icon_container = "#bd93f9";
          bar_container = "#282a36";
        };
        notification = {
          close_button.label = "#282a36";
          close_button.background = "#bd93f9";
          labelicon = "#bd93f9";
          text = "#f8f8f2";
          time = "#6272a4";
          border = "#44475a";
          label = "#bd93f9";
          actions.text = "#282a36";
          actions.background = "#bd93f9";
          background = "#282a36";
        };
      };
    };
  };
}
