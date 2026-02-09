{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  hyprsome = "${pkgs.hyprsome}/bin/hyprsome";
in {
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./hyprpanel.nix
  ];
  home.packages = with pkgs; [
    pkgs.hyprsome
    quicktranslate
    lock
    power-menu
    screenshot
    screenshot-edit
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = ["--all"];
    settings = {
      source = "~/.config/hypr/hyprland_local.conf";
      # https://wiki.hypr.land/Configuring/Variables
      env = [
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
        "HYPRCURSOR_SIZE,32"
      ];
      monitor =
        (lib.optionals (osConfig.networking.hostName == "nyx") [
          "DP-3, 1920x1200@59.95, -1920x0, 1"
          "DP-1, 2560x1440@59.95, 0x0, 1"
          "DP-2, 2560x1440@59.95, 2560x0, 1"
          "Unknown-1, disable"
        ])
        ++ (lib.optionals (osConfig.networking.hostName == "xps") [
          ",highres,auto,1"
          "HDMI-1,preferred,auto,auto" # potential external display
        ])
        ++ (lib.optionals (osConfig.networking.hostName == "zagreus") [
          "DP-2, 2560x1440@240.00,0x0,1"
          # "HDMI-A-1, 1920x1080@60.00Hz,2560x360,1"
        ]);

      general = {
        border_size = 2;
        no_border_on_floating = false;
        gaps_in = 2;
        gaps_out = 4;
        gaps_workspaces = 0;

        float_gaps = 0;
        resize_corner = 0;
        modal_parent_blocking = true;

        "col.inactive_border" = "rgba(282a36ff)";
        "col.active_border" = "rgba(ff79c6ff) rgba(ff6e6eff) 60deg";
        "col.nogroup_border" = "rgba(282a36ff)";
        "col.nogroup_border_active" = "rgba(ff79c6ff) rgba(ff6e6eff) 60deg";
        layout = "dwindle";
        no_focus_fallback = false;
        resize_on_border = true;
        extend_border_grab_area = 15;
        hover_icon_on_border = true;
        allow_tearing = false;

        snap = {
          enabled = false;
          window_gap = 10;
          monitor_gap = 10;
          border_overlap = false;
          respect_gaps = false;
        };
      };

      decoration = {
        rounding = 2;

        rounding_power = 2.0;

        active_opacity = 1.0;
        inactive_opacity = 1.0;
        fullscreen_opacity = 1.0;

        dim_modal = true;

        dim_inactive = false;
        dim_strength = 0.5;
        dim_special = 0.2;
        dim_around = 0.4;

        screen_shader = "";
        border_part_of_window = true;

        blur.enabled = false;
        blur.size = 8;
        blur.passes = 1;
        blur.ignore_opacity = true;
        blur.new_optimizations = true;
        blur.xray = false;
        blur.noise = 0.0117;
        blur.contrast = 0.8916;
        blur.brightness = 0.8172;
        blur.vibrancy = 0.1696;
        blur.vibrancy_darkness = 0.0;
        blur.special = false;
        blur.popups = false;
        blur.popups_ignorealpha = 0.2;
        blur.input_methods = false;
        blur.input_methods_ignorealpha = 0.2;

        shadow.enabled = true;
        shadow.range = 4;
        shadow.render_power = 3;
        shadow.sharp = false;
        shadow.ignore_window = true;
        shadow.color = "0xee1a1a1a";
        shadow.offset = "0 0";
        shadow.scale = 1.0;
      };

      animations = {
        enabled = true;

        workspace_wraparound = false;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 1, myBezier"
          "windowsOut, 1, 1, default, popin 80%"
          "border, 1, 1, default"
          "fade, 1, 1, default"
          "workspaces, 1, 1, default"
        ];
      };

      input = {
        kb_model = "pc105";
        kb_layout = "us";
        kb_variant = "";
        kb_options = "compose:ralt,caps:none";
        kb_rules = "";
        kb_file = "";
        numlock_by_default = false;
        resolve_binds_by_sym = false;
        repeat_rate = 25;
        repeat_delay = 600;
        sensitivity = 0.0;
        accel_profile = "";
        force_no_accel = false;

        rotation = 0;

        left_handed = false;
        scroll_points = "";
        scroll_method = "";
        scroll_button = 0;
        scroll_button_lock = false;
        scroll_factor = 1.0;
        natural_scroll = false;

        follow_mouse = 1;
        follow_mouse_threshold = 0.0;

        focus_on_close = 0;

        mouse_refocus = true;
        float_switch_override_focus = 1;
        special_fallthrough = false;

        off_window_axis_events = 1;
        emulate_discrete_scroll = 1;

        touchpad = {
          disable_while_typing = true;
          natural_scroll = false;
          scroll_factor = 1.0;
          middle_button_emulation = false;
          tap_button_map = "";
          clickfinger_behavior = false;
          tap-to-click = true;
          drag_lock = true;
          tap-and-drag = true;

          flip_x = false;
          flip_y = false;
          drag_3fg = 0;
        };

        touchdevice = {
          transform = -1;
          output = "auto";
          enabled = true;
        };

        virtualkeyboard = {
          share_states = 2;
          release_pressed_on_close = false;
        };

        tablet = {
          transform = -1;
          output = "";
          region_position = "0 0";
          absolute_region_position = false;
          region_size = "0 0";
          relative_input = false;
          left_handed = false;
          active_area_size = "0 0";
          active_area_position = "0 0";
        };
      };

      gestures = {
        workspace_swipe_distance = 100;

        workspace_swipe_touch = false;

        workspace_swipe_invert = false;
        workspace_swipe_touch_invert = false;

        workspace_swipe_min_speed_to_force = 10;
        workspace_swipe_cancel_ratio = 0.5;
        workspace_swipe_create_new = true;
        workspace_swipe_direction_lock = true;
        workspace_swipe_direction_lock_threshold = 10;
        workspace_swipe_forever = true;
        workspace_swipe_use_r = false;

        close_max_timeout = 1000;
      };

      group = {
        auto_group = true;
        insert_after_current = true;
        focus_removed_window = true;

        drag_into_group = 1;
        merge_groups_on_drag = true;
        merge_groups_on_groupbar = true;
        merge_floated_into_tiled_on_groupbar = false;
        group_on_movetoworkspace = false;

        "col.border_active" = "rgba(66ffff00)";
        "col.border_inactive" = "rgba(66ffff00)";
        "col.border_locked_active" = "rgba(66ffff00)";
        "col.border_locked_inactive" = "rgba(66ffff00)";

        groupbar = {
          enabled = true;
          font_family = "FiraCode Nerd Font Mono";
          font_size = 12;

          font_weight_active = "normal";
          font_weight_inactive = "normal";

          gradients = true;
          height = 14;

          indicator_gap = 0;
          indicator_height = 3;
          stacked = false;

          priority = 3;
          render_titles = true;

          text_offset = 0;

          scrolling = false;

          rounding = 1;
          rounding_power = 2.0;
          gradient_rounding = 2;
          gradient_rounding_power = 2.0;
          round_only_edges = true;
          gradient_round_only_edges = true;

          text_color = "rgba(ffffffff)";

          "col.active" = "rgba(6e9bcbff)";
          "col.inactive" = "rgba(282a36ff)";
          "col.locked_active" = "rgba(000000ff)";
          "col.locked_inactive" = "rgba(6e9bcbff)";

          gaps_in = 2;
          gaps_out = 2;
          keep_upper_gap = true;
        };
      };

      misc = {
        enable_anr_dialog = false;

        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_scale_notification = false;

        "col.splash" = "0xffffffff";

        font_family = "Sans";
        splash_font_family = "Sans";
        force_default_wallpaper = -1;

        vfr = true;
        vrr = 0;

        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;

        name_vk_after_proc = true;

        always_follow_on_dnd = true;
        layers_hog_keyboard_focus = true;
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        disable_autoreload = false;

        enable_swallow = false;
        swallow_regex = "Empty";
        swallow_exception_regex = "Empty";

        focus_on_activate = false;
        mouse_move_focuses_monitor = true;

        allow_session_lock_restore = false;
        session_lock_xray = false;

        background_color = "rgba(000000ff)";
        close_special_on_empty = true;

        exit_window_retains_fullscreen = false;
        initial_workspace_tracking = 1;
        middle_click_paste = true;
        render_unfocused_fps = 15;

        disable_xdg_env_checks = false;
        lockdead_screen_delay = 1000;

        anr_missed_pings = 5;
        size_limits_tiled = false;

        new_window_takes_over_fullscreen = 0;
      };

      binds = {
        pass_mouse_when_bound = false;
        scroll_event_delay = 30;
        workspace_back_and_forth = false;

        hide_special_on_workspace_change = false;

        allow_workspace_cycles = false;
        workspace_center_on = 0;
        focus_preferred_method = 0;
        ignore_group_lock = false;

        movefocus_cycles_fullscreen = true;
        movefocus_cycles_groupfirst = false;

        disable_keybind_grabbing = false;

        window_direction_monitor_fallback = true;
        allow_pin_fullscreen = false;
        drag_threshold = 0;
      };

      xwayland = {
        enabled = true;
        use_nearest_neighbor = true;
        force_zero_scaling = false;
        create_abstract_socket = false;
      };

      opengl = {
        nvidia_anti_flicker = true;
      };

      render = {
        direct_scanout = 0;
        expand_undersized_textures = true;
        xp_mode = false;
        ctm_animation = 2;
        cm_fs_passthrough = 2;
        cm_enabled = false;
        send_content_type = true;
        cm_auto_hdr = 1;
        new_render_scheduling = false;
        non_shader_cm = 3;
        cm_sdr_eotf = 0;
      };

      cursor = {
        invisible = false;
        sync_gsettings_theme = true;
        no_hardware_cursors = 2;
        no_break_fs_vrr = 2;
        min_refresh_rate = 24;
        hotspot_padding = 1;
        inactive_timeout = 0.0;
        no_warps = false;
        persistent_warps = false;
        warp_on_change_workspace = 0;
        warp_on_toggle_special = 0;
        default_monitor = "";
        zoom_factor = 1.0;
        zoom_rigid = false;
        enable_hyprcursor = true;
        hide_on_key_press = false;
        hide_on_touch = true;
        use_cpu_buffer = 2;
        warp_back_after_non_mouse_input = false;
        zoom_disable_aa = false;
      };

      ecosystem = {
        no_update_news = true;
        no_donation_nag = false;
        enforce_permissions = false;
      };

      experimental = {
        xx_color_management_v4 = false;
      };

      debug = {
        disable_logs = false;
        disable_time = false;

        overlay = false;
        damage_blink = false;
        damage_tracking = 2;
        enable_stdout_logs = false;
        manual_crash = 0;
        suppress_errors = false;
        disable_scale_checks = false;
        error_limit = 5;
        error_position = 0;
        colored_stdout_logs = true;
        pass = false;
        full_cm_proto = false;
      };

      binde = [
        "SUPER, quote, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 -10%"
        "SUPER, semicolon, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 +10%"
      ];
      bind = [
        "SUPER, up, exec, ${pkgs.brillo}/bin/brillo -q -A 10"
        "SUPER, down, exec, ${pkgs.brillo}/bin/brillo -q -U 10"
        "SUPER, backslash, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-mute 0 toggle"
        "SUPER, a, exec, ${pkgs.wezterm}/bin/wezterm"
        "SUPER, o, exec, ${pkgs.screenshot}/bin/screenshot"
        "SUPER SHIFT, o, exec, ${pkgs.screenshot-edit}/bin/screenshot-edit"
        "SUPER, Return, exec, ${pkgs.wlr-which-key}/bin/wlr-which-key"
        "SUPER, i, exec, ${pkgs.librewolf}/bin/librewolf"

        "SUPER, t, fullscreen"
        "SUPER SHIFT, q, killactive,"
        "SUPER SHIFT, z, exit,"
        "SUPER, space, togglefloating,"

        "SUPER, h, movefocus, l"
        "SUPER, j, movefocus, d"
        "SUPER, k, movefocus, u"
        "SUPER, l, movefocus, r"

        "SUPER, w, exec, ${hyprsome} workspace 1"
        "SUPER, e, exec, ${hyprsome} workspace 2"
        "SUPER, r, exec, ${hyprsome} workspace 3"
        "SUPER, s, exec, ${hyprsome} workspace 4"
        "SUPER, d, exec, ${hyprsome} workspace 5"
        "SUPER, f, exec, ${hyprsome} workspace 6"
        "SUPER, x, exec, ${hyprsome} workspace 7"
        "SUPER, c, exec, ${hyprsome} workspace 8"
        "SUPER, v, exec, ${hyprsome} workspace 9"
        "SUPER, g, exec, ${hyprsome} workspace 10"

        "SUPER SHIFT, w, exec, ${hyprsome} move 1"
        "SUPER SHIFT, e, exec, ${hyprsome} move 2"
        "SUPER SHIFT, r, exec, ${hyprsome} move 3"
        "SUPER SHIFT, s, exec, ${hyprsome} move 4"
        "SUPER SHIFT, d, exec, ${hyprsome} move 5"
        "SUPER SHIFT, f, exec, ${hyprsome} move 6"
        "SUPER SHIFT, x, exec, ${hyprsome} move 7"
        "SUPER SHIFT, c, exec, ${hyprsome} move 8"
        "SUPER SHIFT, v, exec, ${hyprsome} move 9"
        "SUPER SHIFT, g, exec, ${hyprsome} move 10"

        "SUPER,end,resizeactive,20 0"
        "SUPER,home,resizeactive,-20 0"
        "SUPER,pageup,resizeactive,0 -20"
        "SUPER,pagedown,resizeactive,0 20"
      ];
      bindm = [
        "SUPER, mouse:272, movewindow"
      ];

      windowrulev2 =
        [
          "idleinhibit focus, class:^(mpv|.+exe|celluloid)$"
          "idleinhibit focus, title:^(.*YouTube.*)$"
          "idleinhibit focus, title:^(.*Twitch.*)$"
          "suppressevent,class:.*"
        ]
        ++ (lib.optionals (osConfig.networking.hostName == "zagreus") [
          "workspace 3 silent, class:steam"
          "workspace 1 silent, class:^(steam_app_.*)$"
        ]);
      workspace =
        (lib.optionals (osConfig.networking.hostName == "nyx") [
          "DP-3, 1920x1200@59.95, -1920x0, 1"
          "DP-1, 2560x1440@59.95, 0x0, 1"
          "DP-2, 2560x1440@59.95, 2560x0, 1"
          "Unknown-1, disable"
          "21,monitor:DP-3"
          "22,monitor:DP-3"
          "23,monitor:DP-3"
          "24,monitor:DP-3"
          "25,monitor:DP-3"
          "27,monitor:DP-3"
          "28,monitor:DP-3"
          "29,monitor:DP-3"
          "30,monitor:DP-3"
          "1,monitor:DP-1"
          "2,monitor:DP-1"
          "3,monitor:DP-1"
          "4,monitor:DP-1"
          "5,monitor:DP-1"
          "6,monitor:DP-1"
          "7,monitor:DP-1"
          "8,monitor:DP-1"
          "9,monitor:DP-1"
          "10,monitor:DP-1"
          "11,monitor:DP-2"
          "12,monitor:DP-2"
          "13,monitor:DP-2"
          "14,monitor:DP-2"
          "15,monitor:DP-2"
          "17,monitor:DP-2"
          "18,monitor:DP-2"
          "19,monitor:DP-2"
          "20,monitor:DP-2"
        ])
        ++ (lib.optionals (osConfig.networking.hostName == "zagreus") [
          "1,monitor:DP-2"
          "2,monitor:DP-2"
          "3,monitor:DP-2"
          "4,monitor:DP-2"
          "5,monitor:DP-2"
          "6,monitor:DP-2"
          "7,monitor:DP-2"
          "8,monitor:DP-2"
          "9,monitor:DP-2"
          "10,monitor:DP-2"
          "11,monitor:HDMI-A-1"
          "12,monitor:HDMI-A-1"
          "13,monitor:HDMI-A-1"
          "14,monitor:HDMI-A-1"
          "15,monitor:HDMI-A-1"
          "17,monitor:HDMI-A-1"
          "18,monitor:HDMI-A-1"
          "19,monitor:HDMI-A-1"
          "20,monitor:HDMI-A-1"
        ]);
    };
  };
}
