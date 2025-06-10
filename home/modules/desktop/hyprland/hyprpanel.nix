{
  osConfig,
  pkgs,
  ...
}: {
  programs.hyprpanel = {
    enable = true;
    systemd.enable = true;
    hyprland.enable = false;
    overwrite.enable = true; # the config panel will overwrite the config below
    # overlay.enable = true; # doesn't work

    settings = {
      layout = let
        rightModules =
          if osConfig.networking.hostName == "xps"
          then ["volume" "microphone" "network" "bluetooth" "battery" "clock" "notifications"]
          else ["volume" "microphone" "network" "clock" "notifications"];

        commonBarLayout = {
          left = ["workspaces" "windowtitle"];
          middle = [];
          right = rightModules;
        };
      in {
        "bar.layouts" = {
          "0" = commonBarLayout;
          "1" = commonBarLayout;
          "2" = commonBarLayout;
        };
      };
      bar.autoHide = "never";

      bar.battery.hideLabelWhenFull = false;
      bar.battery.label = true;
      bar.battery.middleClick = "";
      bar.battery.rightClick = "";
      bar.battery.scrollDown = "";
      bar.battery.scrollUp = "";

      bar.bluetooth.label = true;
      bar.bluetooth.middleClick = "";
      bar.bluetooth.rightClick = "";
      bar.bluetooth.scrollDown = "";
      bar.bluetooth.scrollUp = "";

      bar.clock.format = "%Y.%m.%d %H:%M:%S";
      bar.clock.icon = "󰸗";
      bar.clock.middleClick = "";
      bar.clock.rightClick = "";
      bar.clock.scrollDown = "";
      bar.clock.scrollUp = "";
      bar.clock.showIcon = true;
      bar.clock.showTime = true;

      bar.customModules.microphone.label = true;
      bar.customModules.microphone.mutedIcon = "󰍭";
      bar.customModules.microphone.unmutedIcon = "󰍬";
      bar.customModules.microphone.leftClick = "menu:audio";
      bar.customModules.microphone.rightClick = "";
      bar.customModules.microphone.middleClick = "";
      bar.customModules.microphone.scrollUp = "";
      bar.customModules.microphone.scrollDown = "";

      bar.customModules.ram.icon = "";
      bar.customModules.ram.label = true;
      bar.customModules.ram.labelType = "percentage";
      bar.customModules.ram.leftClick = "";
      bar.customModules.ram.middleClick = "";
      bar.customModules.ram.pollingInterval = 2000;
      bar.customModules.ram.rightClick = "";
      bar.customModules.ram.round = true;

      bar.network.label = true;
      bar.network.middleClick = "";
      bar.network.rightClick = "";
      bar.network.scrollDown = "";
      bar.network.scrollUp = "";
      bar.network.showWifiInfo = false;
      bar.network.truncation = true;
      bar.network.truncation_size = 50;
      # bar.network.icon = "󰈀"; # Example: Ethernet or Wi-Fi icon

      bar.notifications.hideCountWhenZero = false;
      bar.notifications.middleClick = "";
      bar.notifications.rightClick = "";
      bar.notifications.scrollDown = "";
      bar.notifications.scrollUp = "";
      bar.notifications.show_total = false;

      bar.volume.label = true;
      bar.volume.middleClick = "";
      bar.volume.rightClick = "";
      bar.volume.scrollDown = "${pkgs.hyprpanel}/bin/hyprpanel 'vol -5'";
      bar.volume.scrollUp = "${pkgs.hyprpanel}/bin/hyprpanel 'vol +5'";

      bar.windowtitle.class_name = false;
      bar.windowtitle.custom_title = false;
      bar.windowtitle.icon = true;
      bar.windowtitle.label = true;
      bar.windowtitle.leftClick = "";
      bar.windowtitle.middleClick = "";
      bar.windowtitle.rightClick = "";
      bar.windowtitle.scrollDown = "";
      bar.windowtitle.scrollUp = "";
      bar.windowtitle.truncation = true;
      bar.windowtitle.truncation_size = 50;

      bar.workspaces.applicationIconEmptyWorkspace = "";
      bar.workspaces.applicationIconFallback = "󰣆";
      bar.workspaces.applicationIconOncePerWorkspace = true;
      bar.workspaces.icons.active = "";
      bar.workspaces.icons.available = "";
      bar.workspaces.icons.occupied = "";
      bar.workspaces.ignored = "";
      bar.workspaces.monitorSpecific = true;
      bar.workspaces.numbered_active_indicator = "underline";
      bar.workspaces.reverse_scroll = false;
      bar.workspaces.scroll_speed = 5;
      bar.workspaces.showAllActive = true;
      bar.workspaces.showApplicationIcons = false;
      bar.workspaces.showWsIcons = false;
      bar.workspaces.show_icons = false;
      bar.workspaces.show_numbered = false;
      bar.workspaces.spacing = 1.0;
      bar.workspaces.workspaceMask = false;
      bar.workspaces.workspaces = 1;

      dummy = true;
      hyprpanel.restartAgs = true;
      hyprpanel.restartCommand = "${pkgs.hyprpanel}/bin/hyprpanel q; ${pkgs.hyprpanel}/bin/hyprpanel";
      menus.clock.time.hideSeconds = false;
      menus.clock.time.military = true;
      menus.clock.weather.enabled = false;

      menus.transition = "crossfade";
      menus.transitionTime = 200;
      menus.volume.raiseMaximumVolume = true;

      notifications.active_monitor = true;
      notifications.cache_actions = true;
      notifications.clearDelay = 100;
      notifications.displayedTotal = 10;
      notifications.monitor = 0;
      notifications.position = "top right";
      notifications.showActionsOnHover = false;
      notifications.ignore = [];
      notifications.timeout = 7000;

      scalingPriority = "gdk";
      tear = false;
      terminal = "$TERM";

      theme.bar.border.location = "none";
      theme.bar.border.width = "0.15em";
      theme.bar.border_radius = "0.4em";

      theme.bar.buttons.background_hover_opacity = 100;
      theme.bar.buttons.background_opacity = 85;
      theme.bar.buttons.battery.enableBorder = false;
      theme.bar.buttons.battery.spacing = "0.5em";
      theme.bar.buttons.bluetooth.enableBorder = false;
      theme.bar.buttons.bluetooth.spacing = "0.5em";
      theme.bar.buttons.borderSize = "0.1em";
      theme.bar.buttons.clock.enableBorder = false;
      theme.bar.buttons.clock.spacing = "0.5em";
      theme.bar.buttons.enableBorders = false;
      theme.bar.buttons.innerRadiusMultiplier = "0.4";
      theme.bar.buttons.modules.netstat.enableBorder = false;
      theme.bar.buttons.modules.microphone.enableBorder = false;
      theme.bar.buttons.modules.microphone.spacing = "0.45em";
      theme.bar.buttons.modules.netstat.spacing = "0.45em";
      theme.bar.buttons.modules.weather.enableBorder = false;
      theme.bar.buttons.modules.weather.spacing = "0.45em";
      theme.bar.buttons.monochrome = false;
      theme.bar.buttons.network.enableBorder = false;
      theme.bar.buttons.network.spacing = "0.5em";
      theme.bar.buttons.notifications.enableBorder = false;
      theme.bar.buttons.notifications.spacing = "0.5em";
      theme.bar.buttons.opacity = 100;
      theme.bar.buttons.padding_x = "0.7rem";
      theme.bar.buttons.padding_y = "0.2rem";
      theme.bar.buttons.radius = "0.3em";
      theme.bar.buttons.spacing = "0.25em";
      theme.bar.buttons.style = "default";
      theme.bar.buttons.volume.enableBorder = false;
      theme.bar.buttons.volume.spacing = "0.5em";
      theme.bar.buttons.windowtitle.enableBorder = false;
      theme.bar.buttons.windowtitle.spacing = "0.5em";
      theme.bar.buttons.workspaces.enableBorder = false;
      theme.bar.buttons.workspaces.fontSize = "1.1em";
      theme.bar.buttons.workspaces.numbered_active_highlight_border = "0.2em";
      theme.bar.buttons.workspaces.numbered_active_highlight_padding = "0.2em";
      theme.bar.buttons.workspaces.numbered_inactive_padding = "0.2em";
      theme.bar.buttons.workspaces.pill.active_width = "12em";
      theme.bar.buttons.workspaces.pill.height = "4em";
      theme.bar.buttons.workspaces.pill.radius = "1.9rem * 0.6";
      theme.bar.buttons.workspaces.pill.width = "4em";
      theme.bar.buttons.workspaces.smartHighlight = true;
      theme.bar.buttons.workspaces.spacing = "0.5em";
      theme.bar.buttons.y_margins = "0.4em";

      theme.bar.dropdownGap = "2.9em";
      theme.bar.enableShadow = false;
      theme.bar.floating = false;
      theme.bar.label_spacing = "0.5em";
      theme.bar.layer = "top";
      theme.bar.location = "top";
      theme.bar.margin_bottom = "0em";
      theme.bar.margin_sides = "0.5em";
      theme.bar.margin_top = "0.5em";
      theme.bar.menus.border.radius = "0.7em";
      theme.bar.menus.border.size = "0.13em";
      theme.bar.menus.buttons.radius = "0.4em";
      theme.bar.menus.card_radius = "0.4em";
      theme.bar.menus.enableShadow = false;
      theme.bar.menus.menu.battery.scaling = 100;
      theme.bar.menus.menu.bluetooth.scaling = 100;
      theme.bar.menus.menu.clock.scaling = 100;
      theme.bar.menus.menu.network.scaling = 100;
      theme.bar.menus.menu.notifications.height = "58em";
      theme.bar.menus.menu.notifications.pager.show = true;
      theme.bar.menus.menu.notifications.scaling = 100;
      theme.bar.menus.menu.notifications.scrollbar.radius = "0.2em";
      theme.bar.menus.menu.notifications.scrollbar.width = "0.35em";
      theme.bar.menus.menu.power.radius = "0.4em";
      theme.bar.menus.menu.power.scaling = 90;
      theme.bar.menus.menu.volume.scaling = 100;
      theme.bar.menus.monochrome = false;
      theme.bar.menus.opacity = 100;
      theme.bar.menus.popover.radius = "0.4em";
      theme.bar.menus.popover.scaling = 100;
      theme.bar.menus.progressbar.radius = "0.3rem";
      theme.bar.menus.scroller.radius = "0.7em";
      theme.bar.menus.scroller.width = "0.25em";
      theme.bar.menus.shadow = "0px 0px 3px 1px #16161e";
      theme.bar.menus.shadowMargins = "5px 5px";
      theme.bar.menus.slider.progress_radius = "0.3rem";
      theme.bar.menus.slider.slider_radius = "0.3rem";
      theme.bar.menus.switch.radius = "0.2em";
      theme.bar.menus.switch.slider_radius = "0.2em";
      theme.bar.menus.tooltip.radius = "0.3em";
      theme.bar.opacity = 0;
      theme.bar.outer_spacing = "0em";
      theme.bar.scaling = 100;
      theme.bar.shadow = "0px 1px 2px 1px #16161e";
      theme.bar.shadowMargins = "0px 0px 4px 0px";
      theme.bar.transparent = false;
      theme.font.name = "FiraCode Nerd Font";
      theme.font.size = "1.1rem";
      theme.font.weight = 600;
      theme.matugen = false;
      theme.matugen_settings.contrast = 0;
      theme.matugen_settings.mode = "dark";
      theme.matugen_settings.scheme_type = "tonal-spot";
      theme.matugen_settings.variation = "standard_1";
      theme.name = "dracula";
      theme.notification.border_radius = "0.6em";
      theme.notification.enableShadow = false;
      theme.notification.opacity = 100;
      theme.notification.scaling = 100;
      theme.notification.shadow = "0px 1px 2px 1px #16161e";
      theme.notification.shadowMargins = "4px 4px";
      theme.osd.active_monitor = true;
      theme.osd.duration = 2500;
      theme.osd.enable = true;
      theme.osd.enableShadow = false;
      theme.osd.location = "right";
      theme.osd.margins = "0px 5px 0px 0px";
      theme.osd.monitor = 0;
      theme.osd.muted_zero = false;
      theme.osd.opacity = 100;
      theme.osd.orientation = "vertical";
      theme.osd.radius = "0.4em";
      theme.osd.border.size = "0em";
      theme.osd.scaling = 100;
      theme.osd.shadow = "0px 0px 3px 2px #16161e";
      theme.tooltip.scaling = 100;
      wallpaper.enable = false;
    };
  };
}
