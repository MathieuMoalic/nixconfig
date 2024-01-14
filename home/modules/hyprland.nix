{
  config,
  wallpaperPath,
  ...
}: {
  wayland.windowManager.hyprland = with config.colorScheme.colors; {
    enable = true;
    settings = {
      exec-once = [
        "hyprpaper"
        "dunst"
        "udiskie"
        "brave"
      ];
      monitor = ",highres,auto,1";
      # monitor = [
      #   "DP-3, highres, -1920x0, 1"
      #   "DP-1, highres, 0x0, 1"
      #   "DP-2, highres, 1920x0, 1"
      # ];

      general = {
        gaps_in = 2;
        gaps_out = 4;
        border_size = 2;
        "col.active_border" = "rgba(${base0E}ff) rgba(${base09}ff) 60deg";
        "col.inactive_border" = "rgba(${base00}ff)";
        no_border_on_floating = false;
        cursor_inactive_timeout = 0;
        layout = "dwindle";
        no_cursor_warps = false;
        no_focus_fallback = false;
        apply_sens_to_raw = false;
        resize_on_border = true;
        extend_border_grab_area = 15;
        hover_icon_on_border = true;
      };
      decoration = {
        rounding = 0;
        # multisample_edges = true
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        fullscreen_opacity = 1.0;
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        shadow_ignore_window = true;
        "col.shadow" = "0xee1a1a1a";
        # col.shadow_inactive = unset
        shadow_offset = "[0 0]";
        shadow_scale = 1.0;
        dim_inactive = false;
        dim_strength = 0.5;
        dim_special = 0.2;
        dim_around = 0.4;
        # blur {
        # enabled = false
        # }
      };
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 1, myBezier"
          "windowsOut, 1, 1, default, popin 80%"
          "border, 1, 1, default"
          " fade, 1, 1, default"
          "workspaces, 1, 1, default"
        ];
      };
      input = {
        kb_layout = "us";
        kb_options = "compose:ralt,caps:none";
        numlock_by_default = false;
        repeat_rate = 25;
        repeat_delay = 600;
        sensitivity = 0.0;
        force_no_accel = false;
        left_handed = false;
        scroll_button = 0;
        natural_scroll = false;
        follow_mouse = 1;
        mouse_refocus = true;
        float_switch_override_focus = 1;

        touchpad = {
          natural_scroll = false;
          disable_while_typing = true;
          scroll_factor = 1.0;
          middle_button_emulation = false;
          # tap_button_map =
          clickfinger_behavior = false;
          tap-to-click = true;
          drag_lock = false;
          tap-and-drag = true;
        };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_distance = 100;
        workspace_swipe_invert = false;
        workspace_swipe_min_speed_to_force = 10;
        workspace_swipe_cancel_ratio = 0.5;
        workspace_swipe_create_new = true;
        workspace_swipe_forever = true;
        workspace_swipe_numbered = false;
        workspace_swipe_use_r = false;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_hypr_chan = false;
        vfr = true;
        vrr = 0;
        mouse_move_enables_dpms = false;
        key_press_enables_dpms = false;
        always_follow_on_dnd = true;
        layers_hog_keyboard_focus = true;
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        enable_swallow = false;
        focus_on_activate = false;
        no_direct_scanout = true;
        hide_cursor_on_touch = true;
        mouse_move_focuses_monitor = true;
        render_ahead_of_time = false;
        render_ahead_safezone = 1;
        cursor_zoom_factor = 1.0;
        cursor_zoom_rigid = false;
        allow_session_lock_restore = false;
        background_color = "rgba(000000ff)";
      };
      binds = {
        pass_mouse_when_bound = false;
        scroll_event_delay = 300;
        workspace_back_and_forth = false;
        allow_workspace_cycles = false;
        focus_preferred_method = 0;
      };

      XWayland = {
        use_nearest_neighbor = true;
        force_zero_scaling = false;
      };
      dwindle = {
        # enable pseudotiling. Pseudotiled windows retain their floating size when tiled.
        pseudotile = false;
        # 0 -> split follows mouse, 1 -> always split to the left (new = left or top) 2 -> always split to the right (new = right or bottom)
        force_split = 0;
        # if enabled, the split (side/top) will not change regardless of what happens to the container.
        preserve_split = false;
        # if enabled, allows a more precise control over the window split direction based on the cursor’s position. The window is conceptually divided into four triangles, and cursor’s triangle determines the split direction. This feature also turns on preserve_split.
        smart_split = false;
        # if enabled, resizing direction will be determined by the mouse’s position on the window (nearest to which corner). Else, it is based on the window’s tiling position.;
        smart_resizing = true;
        # if enabled, makes the preselect direction persist until either this mode is turned off, another direction is specified, or a non-direction is specified (anything other than l,r,u/t,d/b)
        permanent_direction_override = false;
        # 0 - 1 -> specifies the scale factor of windows on the special workspace
        special_scale_factor = 0.8;
        # specifies the auto-split width multiplier
        split_width_multiplier = 1.0;
        # whether to apply gaps when there is only one window on a workspace, aka. smart gaps. (default: disabled - 0) no border - 1, with border - 2
        no_gaps_when_only = 0;
        # whether to prefer the active window or the mouse position for splits
        use_active_for_splits = true;
        # the default split ratio on window open. 1 means even 50/50 split. 0.1 - 1.9
        default_split_ratio = 1.0;
      };
      "device:epic mouse V1" = {
        sensitivity = 0;
      };
      windowrulev2 = [
        # # make Firefox PiP window floating and sticky
        # "float, title:^(Picture-in-Picture)$"
        # "pin, title:^(Picture-in-Picture)$"

        # # throw sharing indicators away
        # "workspace special silent, title:^(Firefox — Sharing Indicator)$"
        # "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

        # start spotify in ws9
        "workspace 9 silent, title:^(Spotify( Premium)?)$"

        # idle inhibit while watching videos
        "idleinhibit focus, class:^(mpv|.+exe|celluloid)$"
        "idleinhibit focus, title:^(.*YouTube.*)$"
        # "idleinhibit fullscreen, class:^(brave)$"
      ];
      # windowrulev2 = ["workspace 10, spotify"];
      # l -> locked, aka. works also when an input inhibitor (e.g. a lockscreen) is active.
      # r -> release, will trigger on release of a key.
      # e -> repeat, will repeat when held.
      # n -> non-consuming, key/mouse events will be passed to the active window in addition to triggering the dispatcher.
      # m -> mouse, see below
      # t -> transparent, cannot be shadowed by other binds.
      # i -> ignore mods, will ignore modifiers.
      "$mod" = "SUPER";
      # bindl = [",switch:on:Lid Switch,exec,/home/mat/dl/before_sleep.sh"];
      # examples, check device names with `hyprctl devices`
      # trigger when the switch is turning on
      # bindl=,switch:on:[switch name],exec,hyprctl keyword monitor "eDP-1, 2560x1600, 0x0, 1"
      # trigger when the switch is turning off
      # bindl=,switch:off:[switch name],exec,hyprctl keyword monitor "eDP-1, disable"
      bind = [
        "$mod, up, exec, brillo -q -A 10"
        "$mod, down, exec, brillo -q -U 10"
        "$mod, F1, exec, pactl set-sink-mute 0 toggle"
        "$mod, Return, exec, foot"
        "$mod, J, exec, rofi -modi drun,run -show drun"
        "$mod, N, exec, wireguard-menu"
        "$mod, M, exec, wifi-menu"
        "$mod, T, exec, quick-translate"
        "$mod, L, exec, swaylock"
        "$mod, P, exec, power-menu"
        "$mod, F11, exec, grimblast --notify copy area"
        "$mod, F, fullscreen"
        "$mod, Q, killactive,"
        "$mod SHIFT, E, exit,"
        "$mod, O, togglesplit,"
        "$mod, SPACE, togglefloating,"
        "$mod, G, togglegroup"
        "$mod SHIFT, A, changegroupactive, b"
        "$mod SHIFT, D, changegroupactive, f"

        # Move focus with mod + arrow keys
        "$mod, A, movefocus, l"
        "$mod, D, movefocus, r"
        "$mod, W, movefocus, u"
        "$mod, S, movefocus, d"

        # Move window
        "$mod SHIFT, A, movewindow, l"
        "$mod SHIFT, D, movewindow, r"
        "$mod SHIFT, W, movewindow, u"
        "$mod SHIFT, S, movewindow, d"

        # Switch workspaces with mod + [0-9]
        "$mod, 1, exec, hyprsome workspace 1"
        "$mod, 2, exec, hyprsome workspace 2"
        "$mod, 3, exec, hyprsome workspace 3"
        "$mod, 4, exec, hyprsome workspace 4"
        "$mod, 5, exec, hyprsome workspace 5"
        "$mod, 6, exec, hyprsome workspace 6"
        "$mod, 7, exec, hyprsome workspace 7"
        "$mod, 8, exec, hyprsome workspace 8"
        "$mod, 9, exec, hyprsome workspace 9"
        "$mod, 0, exec, hyprsome workspace 10"

        # Move active window to a workspace with mod + SHIFT + [0-9]
        "$mod SHIFT, 1, exec, hyprsome move 1"
        "$mod SHIFT, 2, exec, hyprsome move 2"
        "$mod SHIFT, 3, exec, hyprsome move 3"
        "$mod SHIFT, 4, exec, hyprsome move 4"
        "$mod SHIFT, 5, exec, hyprsome move 5"
        "$mod SHIFT, 6, exec, hyprsome move 6"
        "$mod SHIFT, 7, exec, hyprsome move 7"
        "$mod SHIFT, 8, exec, hyprsome move 8"
        "$mod SHIFT, 9, exec, hyprsome move 9"
        "$mod SHIFT, 0, exec, hyprsome move 10"

        # Scroll through existing workspaces with mod + scroll
        "$mod, mouse_down, exec, hyprsome workspace e+1"
        "$mod, mouse_up, exec, hyprsome workspace e-1"

        "$mod SHIFT,right,resizeactive,20 0"
        "$mod SHIFT,left,resizeactive,-20 0"
        "$mod SHIFT,up,resizeactive,0 -20"
        "$mod SHIFT,down,resizeactive,0 20"

        "$mod SHIFT,R, movetoworkspace,special"
        "$mod ,R , togglespecialworkspace,"
      ];
      binde = [
        "$mod, F2, exec, pactl set-sink-volume 0 -10%"
        "$mod, F3, exec, pactl set-sink-volume 0 +10%"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
      ];
    };
  };

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${wallpaperPath}
    wallpaper = ,${wallpaperPath}
  '';
}
