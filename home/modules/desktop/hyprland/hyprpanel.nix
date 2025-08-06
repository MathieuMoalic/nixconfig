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

      scalingPriority = "gdk";
      tear = false;
      terminal = "$TERM";

      dummy = true;
      hyprpanel = {
        restartAgs = true;
        restartCommand = "${pkgs.hyprpanel}/bin/hyprpanel q; ${pkgs.hyprpanel}/bin/hyprpanel";
      };

      wallpaper.enable = false;
      bar.autoHide = "never";

      bar = {
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
          border = {
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

          background = colBg;
          border.color = colLabel;

          buttons = {
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
            style = "default";
            y_margins = "0.4em";
            borderColor = colLabel;

            battery = {
              enableBorder = false;
              spacing = "0.5em";
            };
            bluetooth = {
              enableBorder = false;
              spacing = "0.5em";
            };
            clock = {
              enableBorder = false;
              spacing = "0.5em";
            };
            network = {
              enableBorder = false;
              spacing = "0.5em";
            };
            notifications = {
              enableBorder = false;
              spacing = "0.5em";
            };
            volume = {
              enableBorder = false;
              spacing = "0.5em";
            };
            windowtitle = {
              enableBorder = false;
              spacing = "0.5em";
            };
            workspaces = {
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
              microphone = {
                enableBorder = false;
                spacing = "0.45em";
              };
              netstat = {
                enableBorder = false;
                spacing = "0.45em";
              };
              weather = {
                enableBorder = false;
                spacing = "0.45em";
              };
            };
          };

          menus = {
            border = {
              radius = "0.7em";
              size = "0.13em";
            };
            buttons.radius = "0.4em";
            card_radius = "0.4em";
            enableShadow = false;
            monochrome = false;
            opacity = 100;

            background = colDim;
            border.color = colCard;
            cards = colCard;
            label = colLabel;
            text = colText;
            feinttext = colCard;
            dimtext = colDim;

            dropdownmenu = {
              background = colBg;
              divider = colCard;
              text = "#f8f2f2";
            };

            popover = {
              radius = "0.4em";
              scaling = 100;
            };
            progressbar.radius = "0.3rem";
            scroller = {
              radius = "0.7em";
              width = "0.25em";
            };
            shadow = "0px 0px 3px 1px ${colShadow}";
            shadowMargins = "5px 5px";
            slider = {
              progress_radius = "0.3rem";
              slider_radius = "0.3rem";
            };
            switch = {
              radius = "0.2em";
              slider_radius = "0.2em";
            };
            tooltip.radius = "0.3em";

            menu = {
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

        tooltip.scaling = 100;
      };
    };
  };
}
