{
  inputs,
  osConfig,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
  ];
  wayland.windowManager.hyprland.enable = true;

  home.packages = [
    inputs.hyprsome.packages.${pkgs.system}.default
  ];
  wayland.windowManager.hyprland = {
    systemd.variables = ["--all"];
    settings = {
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
          "DP-2, 2560x1440@240.00,auto,1"
        ]);
      exec-once = [
        "${pkgs.hyprpaper}/bin/hyprpaper"
        "${pkgs.hypridle}/bin/hypridle"
      ];
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
        rounding = 0;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        fullscreen_opacity = 1.0;
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        shadow_ignore_window = true;
        "col.shadow" = "0xee1a1a1a";
        shadow_offset = "0, 0";
        shadow_scale = 1.0;
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
        force_introspection = 2;
      };
      debug = {
        disable_logs = false;
        disable_time = false;
      };
      "$mod" = "SUPER";
      binde = [
        "$mod, F2, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 -10%"
        "$mod, F3, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 +10%"
      ];
      bind = [
        "$mod, up, exec, ${pkgs.brillo}/bin/brillo -q -A 10"
        "$mod, down, exec, ${pkgs.brillo}/bin/brillo -q -U 10"
        "$mod, F1, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-mute 0 toggle"
        "$mod, Return, exec, ${pkgs.foot}/bin/foot"
        "$mod, J, exec, ${pkgs.rofi-wayland}/bin/rofi -modi drun,run -show drun"
        "$mod, F11, exec, sc"
        "$mod, N, exec, wireguard-menu"
        "$mod, M, exec, wifi-menu"
        "$mod, T, exec, ${inputs.quicktranslate.packages.${pkgs.system}.quicktranslate}/bin/quicktranslate"
        "$mod, L, exec, lock"
        "$mod, P, exec, power-menu"

        "$mod, F, fullscreen"
        "$mod, Q, killactive,"
        "$mod SHIFT, E, exit,"
        "$mod, O, togglesplit,"
        "$mod, SPACE, togglefloating,"
        "$mod, G, togglegroup"
        "$mod SHIFT, A, changegroupactive, b"
        "$mod SHIFT, D, changegroupactive, f"
        "$mod, A, movefocus, l"
        "$mod, D, movefocus, r"
        "$mod, W, movefocus, u"
        "$mod, S, movefocus, d"

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
        "$mod, mouse_down, exec, hyprsome workspace e+1"
        "$mod, mouse_up, exec, hyprsome workspace e-1"
        "$mod SHIFT,right,resizeactive,20 0"
        "$mod SHIFT,left,resizeactive,-20 0"
        "$mod SHIFT,up,resizeactive,0 -20"
        "$mod SHIFT,down,resizeactive,0 20"
        "$mod SHIFT,R, movetoworkspace,special"
        "$mod ,R , togglespecialworkspace,"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
      ];

      windowrulev2 = [
        "idleinhibit focus, class:^(mpv|.+exe|celluloid)$"
        "idleinhibit focus, title:^(.*YouTube.*)$"
        "idleinhibit focus, title:^(.*Twitch.*)$"
        "suppressevent,class:.*"
      ];
    };
  };
}
