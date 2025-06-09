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
  home.packages = [
    pkgs.hyprsome
    pkgs.quicktranslate
    pkgs.lock
    pkgs.power-menu
    pkgs.screenshot
    pkgs.screenshot-edit
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = ["--all"];
    settings = {
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
          "HDMI-A-1, 1920x1080@60.00Hz,2560x360,1"
        ]);
      general = {
        border_size = 2;
        no_border_on_floating = false;
        gaps_in = 2;
        gaps_out = 4;
        gaps_workspaces = 0;
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
      };
      decoration = {
        rounding = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        fullscreen_opacity = 1.0;
        dim_inactive = false;
        dim_strength = 0.5;
        dim_special = 0.2;
        dim_around = 0.4;
        blur.enabled = false;
      };
      animations = {
        enabled = true;
        first_launch_animation = false;
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
        left_handed = false;
        scroll_points = "";
        scroll_method = "";
        scroll_button = 0;
        scroll_button_lock = false;
        scroll_factor = 1.0;
        natural_scroll = false;
        follow_mouse = 1;
        mouse_refocus = true;
        float_switch_override_focus = 1;
        special_fallthrough = false;
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
        workspace_swipe_direction_lock = true;
        workspace_swipe_direction_lock_threshold = 10;
        workspace_swipe_forever = true;
        workspace_swipe_use_r = false;
      };
      group = {
        insert_after_current = true;
        focus_removed_window = true;
        "col.border_active" = "rgba(66ffff00)";
        "col.border_inactive" = "rgba(66ffff00)";
        "col.border_locked_active" = "rgba(66ffff00)";
        "col.border_locked_inactive" = "rgba(66ffff00)";
        groupbar = {
          enabled = true;
          font_family = "FiraCode Nerd Font Mono";
          font_size = 12;
          gradients = true;
          height = 14;
          priority = 3;
          render_titles = true;
          scrolling = false;
          text_color = "rgba(ffffffff)";
          "col.active" = "rgba(6e9bcbff)";
          "col.inactive" = "rgba(282a36ff)";
          "col.locked_active" = "rgba(000000ff)";
          "col.locked_inactive" = "rgba(6e9bcbff)";
        };
      };
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        "col.splash" = "0xffffffff";
        splash_font_family = "Sans";
        force_default_wallpaper = -1;
        vfr = true;
        vrr = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
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
        render_ahead_of_time = false;
        render_ahead_safezone = 1;
        allow_session_lock_restore = false;
        background_color = "rgba(000000ff)";
        close_special_on_empty = true;
        new_window_takes_over_fullscreen = 0;
      };
      binds = {
        pass_mouse_when_bound = false;
        scroll_event_delay = 300;
        workspace_back_and_forth = false;
        allow_workspace_cycles = false;
        workspace_center_on = 0;
        focus_preferred_method = 0;
        ignore_group_lock = false;
        movefocus_cycles_fullscreen = true;
        disable_keybind_grabbing = false;
      };
      opengl = {
        nvidia_anti_flicker = true;
      };
      debug = {
        disable_logs = false;
        disable_time = false;
      };
      binde = [
        "SUPER, quote, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 -10%"
        "SUPER, semicolon, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 +10%"
      ];
      bind = [
        "SUPER, up, exec, ${pkgs.brillo}/bin/brillo -q -A 10"
        "SUPER, down, exec, ${pkgs.brillo}/bin/brillo -q -U 10"
        "SUPER, backslash, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-mute 0 toggle"
        "SUPER, a, exec, ${pkgs.foot}/bin/foot"
        "SUPER, i, exec, ${pkgs.rofi-wayland}/bin/rofi -modi drun,run -show drun"
        "SUPER, o, exec, ${pkgs.screenshot}/bin/screenshot"
        "SUPER SHIFT, o, exec, ${pkgs.screenshot-edit}/bin/screenshot-edit"
        "SUPER, y, exec, ${pkgs.quicktranslate}/bin/quicktranslate"
        "SUPER, u, exec, ${pkgs.lock}/bin/lock"
        "SUPER, p, exec, ${pkgs.power-menu}/bin/power-menu"

        "SUPER, t, fullscreen"
        "SUPER SHIFT, q, killactive,"
        "SUPER SHIFT, z, exit,"
        "SUPER, m, togglesplit,"
        "SUPER, space, togglefloating,"

        "SUPER SHIFT, j, changegroupactive, b"
        "SUPER SHIFT, k, changegroupactive, f"

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
          "workspace 12 silent, class:steam"
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
