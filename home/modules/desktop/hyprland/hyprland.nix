{
  inputs,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  quicktranslate = inputs.quicktranslate.packages.${pkgs.system}.quicktranslate;
  hyprsome = "${pkgs.hyprsome}/bin/hyprsome";
  lock = import ../scripts/lock.nix {inherit pkgs;};
  power-menu = import ../scripts/power-menu.nix {inherit pkgs;};
  wireguard-menu = import ../scripts/wireguard-menu.nix {inherit pkgs;};
  screenshot = import ../scripts/screenshot.nix {inherit pkgs;};
in {
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
  ];
  home.packages = [
    pkgs.hyprsome
    quicktranslate
    wireguard-menu
    lock
    power-menu
    screenshot
  ];
  wayland.windowManager.hyprland = {
    enable = true;
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
        "$mod, a, exec, ${pkgs.foot}/bin/foot"
        "$mod, i, exec, ${pkgs.rofi-wayland}/bin/rofi -modi drun,run -show drun"
        "$mod, o, exec, ${screenshot}/bin/screenshot"
        "$mod, n, exec, ${wireguard-menu}/bin/wireguard-menu"
        "$mod, t, exec, ${quicktranslate}/bin/quicktranslate"
        "$mod, u, exec, ${lock}/bin/lock"
        "$mod, p, exec, ${power-menu}/bin/power-menu"

        "$mod, g, fullscreen"
        "$mod, q, killactive,"
        "$mod SHIFT, z, exit,"
        "$mod, m, togglesplit,"
        "$mod, code:188, togglefloating," # comma
        "$mod, code:190, togglegroup" # period

        # "$mod SHIFT, J, changegroupactive, b"
        # "$mod SHIFT, code:59, changegroupactive, f"
        "$mod, J, movefocus, l"
        "$mod, semicolon, movefocus, r"
        "$mod, L, movefocus, u"
        "$mod, K, movefocus, d"

        "$mod, w, exec, ${hyprsome} workspace 1"
        "$mod, e, exec, ${hyprsome} workspace 2"
        "$mod, r, exec, ${hyprsome} workspace 3"
        "$mod, s, exec, ${hyprsome} workspace 4"
        "$mod, d, exec, ${hyprsome} workspace 5"
        "$mod, f, exec, ${hyprsome} workspace 6"
        "$mod, x, exec, ${hyprsome} workspace 7"
        "$mod, c, exec, ${hyprsome} workspace 8"
        "$mod, v, exec, ${hyprsome} workspace 9"
        "$mod, g, exec, ${hyprsome} workspace 10"
        "$mod SHIFT, w, exec, ${hyprsome} move 1"
        "$mod SHIFT, e, exec, ${hyprsome} move 2"
        "$mod SHIFT, r, exec, ${hyprsome} move 3"
        "$mod SHIFT, s, exec, ${hyprsome} move 4"
        "$mod SHIFT, d, exec, ${hyprsome} move 5"
        "$mod SHIFT, f, exec, ${hyprsome} move 6"
        "$mod SHIFT, x, exec, ${hyprsome} move 7"
        "$mod SHIFT, c, exec, ${hyprsome} move 8"
        "$mod SHIFT, v, exec, ${hyprsome} move 9"
        "$mod SHIFT, g, exec, ${hyprsome} move 10"

        # "$mod SHIFT,right,resizeactive,20 0"
        # "$mod SHIFT,left,resizeactive,-20 0"
        # "$mod SHIFT,up,resizeactive,0 -20"
        # "$mod SHIFT,down,resizeactive,0 20"
        # "$mod SHIFT,R, movetoworkspace,special"
        # "$mod ,R , togglespecialworkspace,"
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
