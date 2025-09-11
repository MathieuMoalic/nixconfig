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
        then ["network" "volume" "microphone" "bluetooth" "battery" "clock" "notifications"]
        else ["network" "volume" "microphone" "clock" "notifications"];

      commonBarLayout = {
        left = ["workspaces" "windowtitle"];
        middle = ["media"];
        right = rightModules;
      };
    in {
      "bar.layouts" = {
        "0" = commonBarLayout;
        "1" = commonBarLayout;
        "2" = commonBarLayout;
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
      bar = {
        autoHide = "never";
        battery = {
          hideLabelWhenFull = false;
          label = true;
          middleClick = "";
          rightClick = "";
          scrollDown = "";
          scrollUp = "";
        };

        bluetooth = {
          label = true;
          middleClick = "";
          rightClick = "";
          scrollDown = "";
          scrollUp = "";
        };

        clock = {
          format = "%Y.%m.%d %H:%M:%S";
          icon = "󰸗";
          showIcon = true;
          showTime = true;
          middleClick = "";
          rightClick = "";
          scrollDown = "";
          scrollUp = "";
        };

        customModules = {
          microphone = {
            label = true;
            mutedIcon = "󰍭";
            unmutedIcon = "󰍬";
            leftClick = "menu:audio";
            rightClick = "";
            middleClick = "";
            scrollUp = "";
            scrollDown = "";
          };
        };

        network = {
          label = true;
          middleClick = "";
          rightClick = "";
          scrollDown = "";
          scrollUp = "";
          showWifiInfo = false;
          truncation = true;
          truncation_size = 50;
        };

        notifications = {
          hideCountWhenZero = false;
          middleClick = "";
          rightClick = "";
          scrollDown = "";
          scrollUp = "";
          show_total = false;
        };

        volume = {
          label = true;
          middleClick = "";
          rightClick = "";
          scrollDown = "${pkgs.hyprpanel}/bin/hyprpanel 'vol -5'";
          scrollUp = "${pkgs.hyprpanel}/bin/hyprpanel 'vol +5'";
        };

        windowtitle = {
          class_name = false;
          custom_title = false;
          icon = true;
          label = true;
          leftClick = "";
          middleClick = "";
          rightClick = "";
          scrollDown = "";
          scrollUp = "";
          truncation = true;
          truncation_size = 50;
        };

        workspaces = {
          applicationIconEmptyWorkspace = "";
          applicationIconFallback = "󰣆";
          applicationIconOncePerWorkspace = true;
          icons = {
            active = "";
            available = "";
            occupied = "";
          };
          ignored = "";
          monitorSpecific = true;
          numbered_active_indicator = "underline";
          reverse_scroll = false;
          scroll_speed = 5;
          showAllActive = true;
          showApplicationIcons = false;
          showWsIcons = false;
          show_icons = false;
          show_numbered = false;
          spacing = 1.0;
          workspaceMask = false;
          workspaces = 1;
        };
      };

      menus = {
        clock = {
          time = {
            hideSeconds = false;
            military = true;
          };
          weather.enabled = false;
        };
        transition = "crossfade";
        transitionTime = 200;
        volume.raiseMaximumVolume = true;
      };

      notifications = {
        active_monitor = true;
        cache_actions = true;
        clearDelay = 100;
        displayedTotal = 10;
        monitor = 0;
        position = "top right";
        showActionsOnHover = false;
        ignore = [];
        timeout = 7000;
      };

      theme = let
        colBg = "#282a36";
        colCard = "#44475a";
        colLabel = "#bd93f9";
        colDim = "#6272a4";
        colText = "#f8f8f2";
        colShadow = "#16161e";
        colRed = "#ff5555";
      in {
        bar = {
          background = colBg;

          border = {
            color = "#bd93f9";
            location = "none";
            width = "0.15em";
          };

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
          shadow = "0px 1px 2px 1px ${colShadow}";
          shadowMargins = "0px 0px 4px 0px";
          transparent = false;

          buttons = {
            background = "#282936";
            borderColor = "#bd93f9";
            style = "default";
            icon = "#bd93f9";
            text = "#bd93f9";
            hover = "#44475a";
            icon_background = "#44475a";

            background_hover_opacity = 100;
            background_opacity = 85;
            borderSize = "0.1em";
            enableBorders = false;
            innerRadiusMultiplier = "0.4";
            monochrome = false;
            opacity = 100;
            padding_x = "0.7rem";
            padding_y = "0.2rem";
            radius = "0.3em";
            spacing = "0.25em";
            y_margins = "0.4em";

            workspaces = {
              numbered_active_underline_color = "#e23ee2";
              numbered_active_highlighted_text_color = "#21252b";
              active = "#ff79c6";
              occupied = "#ffb86c";
              available = "#8be9fd";
              hover = "#44475a";
              background = "#44475a";
              border = "#44475a";

              enableBorder = false;
              fontSize = "1.1em";
              numbered_active_highlight_border = "0.2em";
              numbered_active_highlight_padding = "0.2em";
              numbered_inactive_padding = "0.2em";
              smartHighlight = true;
              spacing = "0.5em";

              pill = {
                active_width = "12em";
                height = "4em";
                radius = "1.9rem * 0.6";
                width = "4em";
              };
            };

            modules = {
              cava = {
                text = "#8be9fd";
                background = "#44475a";
                icon_background = "#44475a";
                icon = "#8be9fd";
                border = "#8be9fd";
              };
              microphone = {
                icon = "#50fa7b";
                text = "#50fa7b";
                background = "#44475a";
                border = "#50fa7b";
                icon_background = "#44475a";
                enableBorder = false;
                spacing = "0.45em";
              };
              hyprsunset = {
                icon = "#f1fa8c";
                text = "#f1fa8c";
                background = "#44475a";
                border = "#f1fa8c";
                icon_background = "#f1fa8c";
              };
              hypridle = {
                icon = "#bd93f9";
                text = "#bd93f9";
                background = "#44475a";
                border = "#bd93f9";
                icon_background = "#bd93f9";
              };
              worldclock = {
                icon = "#ff79c6";
                text = "#ff79c6";
                background = "#44475a";
                border = "#ff79c6";
                icon_background = "#ff79c6";
              };
            };
          };

          menus = {
            tooltip = {
              text = "#f8f8f2";
              background = "#282a36";
              radius = "0.3em";
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
              progress_radius = "0.3rem";
              slider_radius = "0.3rem";
            };

            progressbar = {
              background = "#44475a";
              foreground = "#bd93f9";
              radius = "0.3rem";
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
              radius = "0.4em";
            };

            check_radio_button = {
              active = "#bd93f9";
              background = "#282936";
            };

            switch = {
              puck = "#44475a";
              disabled = "#44475a";
              enabled = "#bd93f9";
              radius = "0.2em";
              slider_radius = "0.2em";
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
              radius = "0.4em";
              scaling = 100;
            };

            label = "#bd93f9";
            feinttext = "#44475a";
            dimtext = "#6272a4";
            text = "#f8f8f2";

            border = {
              color = "#44475a";
              radius = "0.7em";
              size = "0.13em";
            };

            cards = "#44475a";
            background = "#6272a4";

            opacity = 100;
            monochrome = false;
            enableShadow = false;
            card_radius = "0.4em";
            shadow = "0px 0px 3px 1px ${colShadow}";
            shadowMargins = "5px 5px";

            scroller = {
              radius = "0.7em";
              width = "0.25em";
            };

            menu = {
              network = {
                switch = {
                  enabled = "#bd93f9";
                  disabled = "#44475a";
                  puck = "#44475a";
                };
                scroller.color = "#bd93f9";
              };
              bluetooth.scroller.color = "#8be9fd";
              media.timestamp = "#f8f8f2";

              battery.scaling = 100;
              bluetooth.scaling = 100;
              clock.scaling = 100;
              network.scaling = 100;
              volume.scaling = 100;

              power = {
                radius = "0.4em";
                scaling = 90;
              };

              notifications = {
                height = "58em";
                scaling = 100;
                pager.show = true;
                scrollbar = {
                  radius = "0.2em";
                  width = "0.35em";
                };
              };
            };
          };

          theme = {
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
              close_button = {
                label = "#282a36";
                background = "#bd93f9";
              };
              labelicon = "#bd93f9";
              text = "#f8f8f2";
              time = "#6272a4";
              border = "#44475a";
              label = "#bd93f9";
              actions = {
                text = "#282a36";
                background = "#bd93f9";
              };
              background = "#282a36";
            };
          };
        };

        notification = {
          border_radius = "0.6em";
          enableShadow = false;
          opacity = 100;
          scaling = 100;
          shadow = "0px 1px 2px 1px ${colShadow}";
          shadowMargins = "4px 4px";
          background = colBg;
          border = colCard;
          label = colLabel;
          text = colText;
          time = colDim;
          close_button = {
            label = colBg;
            background = colLabel;
          };
          actions = {
            text = colBg;
            background = colLabel;
          };
        };

        osd = {
          active_monitor = true;
          duration = 2500;
          enable = true;
          enableShadow = false;
          location = "right";
          margins = "0px 5px 0px 0px";
          monitor = 0;
          muted_zero = false;
          opacity = 100;
          orientation = "vertical";
          radius = "0.4em";
          border.size = "0em";
          scaling = 100;
          shadow = "0px 0px 3px 2px ${colShadow}";
          label = colLabel;
          icon = colBg;
          bar_color = colLabel;
          bar_empty_color = colCard;
          bar_overflow_color = colRed;
          icon_container = colLabel;
          bar_container = colBg;
        };

        tooltip = {
          scaling = 100;
        };
      };
    };
  };
}
