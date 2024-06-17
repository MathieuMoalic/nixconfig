{
  inputs,
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = with config.colorScheme.palette; {
    systemd.variables = ["--all"];
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    # package = pkgs.hyprland;
    settings = {
      monitor =
        (lib.optionals (osConfig.networking.hostName == "nyx") [
          "DP-3, 1920x1200@59.95000, -1920x0, 1"
          "DP-1, 1920x1200@59.95000, 0x0, 1"
          "DP-2, 1920x1200@59.95000, 1920x0, 1"
        ])
        ++ (lib.optionals (osConfig.networking.hostName == "xps") [
          ",highres,auto,1"
          "HDMI-1,preferred,auto,auto" # potential external display
        ]);
    };
    extraConfig = ''
      exec-once=${pkgs.hyprpaper}/bin/hyprpaper
      exec-once=${pkgs.hypridle}/bin/hypridle
      exec-once=${pkgs.dunst}/bin/dunst
      exec-once=${pkgs.udiskie}/bin/udiskie

      general {
        sensitivity = 1.0 # mouse sensitivity (legacy, may cause bugs if not 1, prefer input:sensitivity)
        border_size = 2 # size of the border around windows
        no_border_on_floating = false # disable borders for floating windows
        gaps_in = 2 # gaps between windows, also supports css style gaps (top, right, bottom, left -> 5,10,15,20)
        gaps_out = 4 # gaps between windows and monitor edges, also supports css style gaps (top, right, bottom, left -> 5,10,15,20)
        gaps_workspaces = 0 # gaps between workspaces. Stacks with gaps_out.
        col.inactive_border = rgba(282a36ff) # border color for inactive windows
        col.active_border = rgba(ff79c6ff) rgba(ff6e6eff) 60deg # border color for the active window
        col.nogroup_border = rgba(282a36ff) # inactive border color for window that cannot be added to a group (see denywindowfromgroup dispatcher)
        col.nogroup_border_active = rgba(ff79c6ff) rgba(ff6e6eff) 60deg # active border color for window that cannot be added to a group
        cursor_inactive_timeout = 0 # in seconds, after how many seconds of cursor's inactivity to hide it. Set to 0 for never.
        layout = dwindle # which layout to use. [dwindle/master]
        no_cursor_warps = false # if true, will not warp the cursor in many cases (focusing, keybinds, etc)
        no_focus_fallback = false # if true, will not fall back to the next available window when moving focus in a direction where no window was found
        apply_sens_to_raw = false # if on, will also apply the sensitivity to raw mouse output (e.g. sensitivity in games) NOTICE: really not recommended.
        resize_on_border = true # enables resizing windows by clicking and dragging on borders and gaps
        extend_border_grab_area = 15 # extends the area around the border where you can click and drag on, only used when general:resize_on_border is on.
        hover_icon_on_border = true # show a cursor icon when hovering over borders, only used when general:resize_on_border is on.
        allow_tearing = false # master switch for allowing tearing to occur. See the Tearing page.
        # resize_corner = 0 # force floating windows to use a specific corner when being resized (1-4 going clockwise from top left, 0 to disable)
      }

      decoration {
        rounding = 0 # rounded corners' radius (in layout px)
        active_opacity = 1.0 # opacity of active windows. [0.0 - 1.0]
        inactive_opacity = 1.0 # opacity of inactive windows. [0.0 - 1.0]
        fullscreen_opacity = 1.0 # opacity of fullscreen windows. [0.0 - 1.0]
        drop_shadow = true # enable drop shadows on windows
        shadow_range = 4 # Shadow range (“size”) in layout px
        shadow_render_power = 3 # in what power to render the falloff (more power, the faster the falloff) [1 - 4]
        shadow_ignore_window = true # if true, the shadow will not be rendered behind the window itself, only around it.
        col.shadow = 0xee1a1a1a # shadow's color. Alpha dictates shadow's opacity.
        # col.shadow_inactive = unset # inactive shadow color. (if not set, will fall back to col.shadow)
        shadow_offset = 0, 0 # shadow's rendering offset.
        shadow_scale = 1.0 # shadow's scale. [0.0 - 1.0]
        dim_inactive = false # enables dimming of inactive windows
        dim_strength = 0.5 # how much inactive windows should be dimmed [0.0 - 1.0]
        dim_special = 0.2 # how much to dim the rest of the screen by when a special workspace is open. [0.0 - 1.0]
        dim_around = 0.4 # how much the dimaround window rule should dim by. [0.0 - 1.0]
        # screen_shader = [[Empty]] # a path to a custom shader to be applied at the end of rendering. See examples/screenShader.frag for an example.
        blur {
          enabled = false # enable blur
        }
      }

      animations {
        first_launch_animation = false # whether to play the first launch animation
        bezier=myBezier, 0.05, 0.9, 0.1, 1.05
        animation=windows, 1, 1, myBezier
        animation=windowsOut, 1, 1, default, popin 80%
        animation=border, 1, 1, default
        animation= fade, 1, 1, default
        animation=workspaces, 1, 1, default
        enabled=true
      }

      input {
        kb_model= # Appropriate XKB keymap parameter. See the note below.
        kb_layout=us # Appropriate XKB keymap parameter
        kb_variant= # Appropriate XKB keymap parameter
        kb_options=compose:ralt,caps:none # Appropriate XKB keymap parameter
        kb_rules= # Appropriate XKB keymap parameter
        kb_file= # If you prefer, you can use a path to your custom .xkb file.
        numlock_by_default=false # Engage numlock by default.
        resolve_binds_by_sym=false # Determines how keybinds act when multiple layouts are used. If false, keybinds will always act as if the first specified layout were active. If true, keybinds specified by symbols activate if you type the respective symbol with the current layout.
        repeat_rate=25 # The repeat rate for held-down keys, in repeats per second.
        repeat_delay=600 # Delay before a held-down key is repeated, in milliseconds.
        sensitivity=0.0 # Sets the mouse input sensitivity. Value will be clamped to the range -1.0 to 1.0.
        accel_profile= # Sets the cursor acceleration profile. Can be one of adaptive, flat. Can also be custom, see below. Leave empty to use libinput's default mode for your input device.
        force_no_accel=false # Force no cursor acceleration. This bypasses most of your pointer settings to get as raw of a signal as possible. Enabling this is not recommended due to potential cursor desynchronization.
        left_handed=false # Switches RMB and LMB
        scroll_points= # Sets the scroll acceleration profile, when accel_profile is set to custom. Has to be in the form <step> <points>. Leave empty to have a flat scroll curve.
        scroll_method= # Sets the scroll method. Can be one of 2fg (2 fingers), edge, on_button_down, no_scroll.
        scroll_button=0 # Sets the scroll button. Has to be an int, cannot be a string. Check wev if you have any doubts regarding the ID. 0 means default.
        scroll_button_lock=false # If the scroll button lock is enabled, the button does not need to be held down. Pressing and releasing the button once enables the button lock, the button is now considered logically held down. Pressing and releasing the button a second time logically releases the button. While the button is logically held down, motion events are converted to scroll events.
        scroll_factor=1.0 # Multiplier added to scroll movement for external mice. Note that there is a separate setting for touchpad scroll_factor.
        natural_scroll=false # Inverts scrolling direction. When enabled, scrolling moves content directly instead of manipulating a scrollbar.
        follow_mouse=1 # Specify if and how cursor movement should affect window focus. See the note below.
        mouse_refocus=true # If disabled and follow_mouse=1 then mouse focus will not switch to the hovered window unless the mouse crosses a window boundary.
        float_switch_override_focus=1 # If enabled (1 or 2), focus will change to the window under the cursor when changing from tiled-to-floating and vice versa. If 2, focus will also follow mouse on float-to-float switches.
        special_fallthrough=false # if enabled, having only floating windows in the special workspace will not block focusing windows in the regular workspace.
        touchpad {
          disable_while_typing=true # Disable the touchpad while typing.
          natural_scroll=false # Inverts scrolling direction. When enabled, scrolling moves content directly instead of manipulating a scrollbar.
          scroll_factor=1.0 # Multiplier applied to the amount of scroll movement.
          middle_button_emulation=false # Sending LMB and RMB simultaneously will be interpreted as a middle click. This disables any touchpad area that would normally send a middle click based on location.
          tap_button_map= # Sets the tap button mapping for touchpad button emulation. Can be one of lrm (default) or lmr (Left, Middle, Right Buttons).
          clickfinger_behavior=false # Button presses with 1, 2, or 3 fingers will be mapped to LMB, RMB, and MMB respectively. This disables interpretation of clicks based on location on the touchpad.
          tap-to-click=true # Tapping on the touchpad with 1, 2, or 3 fingers will send LMB, RMB, and MMB respectively.
          drag_lock=true # When enabled, lifting the finger off for a short time while dragging will not drop the dragged item.
          tap-and-drag=true # Sets the tap and drag mode for the touchpad
        }
      }

      gestures {
        workspace_swipe = true # enable workspace swipe gesture on touchpad
        workspace_swipe_fingers = 3 # how many fingers for the touchpad gesture
        workspace_swipe_distance = 100 # in px, the distance of the touchpad gesture
        # workspace_swipe_touch = false # enable workspace swiping from the edge of a touchscreen
        workspace_swipe_invert = false # invert the direction
        workspace_swipe_min_speed_to_force = 10 # minimum speed in px per timepoint to force the change ignoring cancel_ratio. Setting to 0 will disable this mechanic.
        workspace_swipe_cancel_ratio = 0.5 # how much the swipe has to proceed in order to commence it. (0.7 -> if > 0.7 * distance, switch, if less, revert) [0.0 - 1.0]
        workspace_swipe_create_new = true # whether a swipe right on the last workspace should create a new one.
        workspace_swipe_direction_lock = true # if enabled, switching direction will be locked when you swipe past the direction_lock_threshold (touchpad only).
        workspace_swipe_direction_lock_threshold = 10 # in px, the distance to swipe before direction lock activates (touchpad only).
        workspace_swipe_forever = true # if enabled, swiping will not clamp at the neighboring workspaces but continue to the further ones.
        # workspace_swipe_numbered = false # if enabled, swiping will swipe on consecutive numbered workspaces.
        workspace_swipe_use_r = false # if enabled, swiping will use the r prefix instead of the m prefix for finding workspaces. (requires disabled workspace_swipe_numbered)
      }

      group {
        insert_after_current=true # whether new windows in a group spawn after current or at group tail
        focus_removed_window=true # whether Hyprland should focus on the window that has just been moved out of the group
        col.border_active=rgba(66ffff00) # active group border color
        col.border_inactive=rgba(66ffff00) # inactive (out of focus) group border color
        col.border_locked_active=rgba(66ffff00) # active locked group border color
        col.border_locked_inactive=rgba(66ffff00) # inactive locked group border color

        groupbar {
          enabled=true # enables groupbars
          font_family=FiraCode Nerd Font Mono # font used to display groupbar titles
          font_size=12 # font size for the above
          gradients=true # enables gradients
          height=14 # height of the groupbar
          priority=3 # sets the decoration priority for groupbars
          render_titles=true # whether to render titles in the group bar decoration
          scrolling=false # whether scrolling in the groupbar changes group active window
          text_color=rgba(ffffffff) # controls the group bar text color
          col.active=rgba(6e9bcbff) # active group border color
          col.inactive=rgba(282a36ff) # inactive (out of focus) group border color
          col.locked_active=rgba(000000ff) # active locked group border color
          col.locked_inactive=rgba(6e9bcbff) # inactive locked group border color
        }
      }

      misc {
        disable_hyprland_logo = true # disables the random hyprland logo
        disable_splash_rendering = true # disables the hyprland splash rendering. (requires a monitor reload to take effect)
        col.splash = 0xffffffff # Changes the color of the splash text (requires a monitor reload to take effect).
        splash_font_family = Sans # Changes the font used to render the splash text, selected from system fonts (requires a monitor reload to take effect).
        force_default_wallpaper = -1 # Enforce any of the 3 default wallpapers. Setting this to 0 disables the anime background. -1 means “random” [-1 - 3]
        vfr = true # controls the VFR status of hyprland. Heavily recommended to leave on true to conserve resources.
        vrr = 0 # controls the VRR (Adaptive Sync) of your monitors. 0 - off, 1 - on, 2 - fullscreen only [0/1/2]
        mouse_move_enables_dpms = true # If DPMS is set to off, wake up the monitors if the mouse moves.
        key_press_enables_dpms = true # If DPMS is set to off, wake up the monitors if a key is pressed.
        always_follow_on_dnd = true # Will make mouse focus follow the mouse when drag and dropping. Recommended to leave it enabled, especially for people using focus follows mouse at 0.
        layers_hog_keyboard_focus = true # If true, will make keyboard-interactive layers keep their focus on mouse move (e.g. wofi, bemenu)
        animate_manual_resizes = true # If true, will animate manual window resizes/moves
        animate_mouse_windowdragging = true # If true, will animate windows being dragged by mouse, note that this can cause weird behavior on some curves
        disable_autoreload = false # If true, the config will not reload automatically on save, and instead needs to be reloaded with hyprctl reload. Might save on battery.
        enable_swallow = false # Enable window swallowing
        swallow_regex = [[Empty]] # The class regex to be used for windows that should be swallowed (usually, a terminal). To know more about the list of regex which can be used use this cheatsheet.
        swallow_exception_regex = [[Empty]] # The title regex to be used for windows that should not be swallowed by the windows specified in swallow_regex (e.g. wev). The regex is matched against the parent (e.g. Kitty) window's title on the assumption that it changes to whatever process it's running.
        focus_on_activate = false # Whether Hyprland should focus an app that requests to be focused (an activate request)
        no_direct_scanout = true # Disables direct scanout. Direct scanout attempts to reduce lag when there is only one fullscreen application on a screen (e.g. game). It is also recommended to set this to true if the fullscreen application shows graphical glitches.
        hide_cursor_on_touch = true # Hides the cursor when the last input was a touch input until a mouse input is done.
        # hide_cursor_on_key_press = true # Hides the cursor when you press any key until the mouse is moved.
        mouse_move_focuses_monitor = true # Whether mouse moving into a different monitor should focus it
        # suppress_portal_warnings = false # disables warnings about incompatible portal implementations.
        render_ahead_of_time = false # [Warning: buggy] starts rendering before your monitor displays a frame in order to lower latency
        render_ahead_safezone = 1 # how many ms of safezone to add to rendering ahead of time. Recommended 1-2.
        cursor_zoom_factor = 1.0 # the factor to zoom by around the cursor. AKA. Magnifying glass. Minimum 1.0 (meaning no zoom)
        cursor_zoom_rigid = false # whether the zoom should follow the cursor rigidly (cursor is always centered if it can be)
        allow_session_lock_restore = false # if true, will allow you to restart a lockscreen app in case it crashes (red screen of death)
        background_color = rgba(000000ff) # change the background color. (requires enabled disable_hyprland_logo)
        close_special_on_empty = true # close the special workspace if the last window is removed
        new_window_takes_over_fullscreen = 0 # if there is a fullscreen window, whether a new tiled window opened should replace the fullscreen one or stay behind. 0 - behind, 1 - takes over, 2 - unfullscreen the current fullscreen window [0/1/2]
        enable_hyprcursor = true # whether to enable hyprcursor support
      }

      binds {
        pass_mouse_when_bound = false # if disabled, will not pass the mouse events to apps / dragging windows around if a keybind has been triggered.
        scroll_event_delay = 300 # in ms, how many ms to wait after a scroll event to allow to pass another one for the binds.
        workspace_back_and_forth = false # If enabled, an attempt to switch to the currently focused workspace will instead switch to the previous workspace. Akin to i3's auto_back_and_forth.
        allow_workspace_cycles = false # If enabled, workspaces don't forget their previous workspace, so cycles can be created by switching to the first workspace in a sequence, then endlessly going to the previous workspace.
        workspace_center_on = 0 # Whether switching workspaces should center the cursor on the workspace (0) or on the last active window for that workspace (1)
        focus_preferred_method = 0 # sets the preferred focus finding method when using focuswindow/movewindow/etc with a direction. 0 - history (recent have priority), 1 - length (longer shared edges have priority)
        ignore_group_lock = false # If enabled, dispatchers like moveintogroup, moveoutofgroup and movewindoworgroup will ignore lock per group.
        movefocus_cycles_fullscreen = true # If enabled, when on a fullscreen window, movefocus will cycle fullscreen, if not, it will move the focus in a direction.
        # disable_keybind_grabbing = false # If enabled, keybinds will not be grabbed by Hyprland, allowing other applications to use them.
      }
      opengl {
        nvidia_anti_flicker = true # reduces flickering on nvidia at the cost of possible frame drops on lower-end GPUs. On non-nvidia, this is ignored.
        force_introspection = 2 # forces introspection at all times. Introspection is aimed at reducing GPU usage in certain cases, but might cause graphical glitches on nvidia. 0 - nothing, 1 - force always on, 2 - force always on if nvidia
      }
      debug {
        disable_logs = false
        disable_time = false
      }

      $mod=SUPER

      bind=$mod, up, exec, ${pkgs.brillo}/bin/brillo -q -A 10
      bind=$mod, down, exec, ${pkgs.brillo}/bin/brillo -q -U 10
      bind=$mod, F1, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-mute 0 toggle
      binde=$mod, F2, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 -10%
      binde=$mod, F3, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 +10%
      bind=$mod, Return, exec, ${pkgs.foot}/bin/foot
      bind=$mod, J, exec, ${pkgs.rofi-wayland}/bin/rofi -modi drun,run -show drun
      bind=$mod, F11, exec,  ${pkgs.grimblast}/bin/grimblast --notify copy area
      bind=$mod, N, exec, wireguard-menu
      bind=$mod, M, exec, wifi-menu
      bind=$mod, T, exec, quicktranslate
      bind=$mod, L, exec, lock
      bind=$mod, P, exec, power-menu

      bind=$mod, F, fullscreen
      bind=$mod, Q, killactive,
      bind=$mod SHIFT, E, exit,

      bind=$mod, O, togglesplit,
      bind=$mod, SPACE, togglefloating,

      bind=$mod, G, togglegroup
      bind=$mod SHIFT, A, changegroupactive, b
      bind=$mod SHIFT, D, changegroupactive, f

      bind=$mod, A, movefocus, l
      bind=$mod, D, movefocus, r
      bind=$mod, W, movefocus, u
      bind=$mod, S, movefocus, d
      # bind=$mod SHIFT, A, movewindow, l
      # bind=$mod SHIFT, D, movewindow, r
      # bind=$mod SHIFT, W, movewindow, u
      # bind=$mod SHIFT, S, movewindow, d
      bind=$mod, 1, exec, hyprsome workspace 1
      bind=$mod, 2, exec, hyprsome workspace 2
      bind=$mod, 3, exec, hyprsome workspace 3
      bind=$mod, 4, exec, hyprsome workspace 4
      bind=$mod, 5, exec, hyprsome workspace 5
      bind=$mod, 6, exec, hyprsome workspace 6
      bind=$mod, 7, exec, hyprsome workspace 7
      bind=$mod, 8, exec, hyprsome workspace 8
      bind=$mod, 9, exec, hyprsome workspace 9
      bind=$mod, 0, exec, hyprsome workspace 10
      bind=$mod SHIFT, 1, exec, hyprsome move 1
      bind=$mod SHIFT, 2, exec, hyprsome move 2
      bind=$mod SHIFT, 3, exec, hyprsome move 3
      bind=$mod SHIFT, 4, exec, hyprsome move 4
      bind=$mod SHIFT, 5, exec, hyprsome move 5
      bind=$mod SHIFT, 6, exec, hyprsome move 6
      bind=$mod SHIFT, 7, exec, hyprsome move 7
      bind=$mod SHIFT, 8, exec, hyprsome move 8
      bind=$mod SHIFT, 9, exec, hyprsome move 9
      bind=$mod SHIFT, 0, exec, hyprsome move 10
      bind=$mod, mouse_down, exec, hyprsome workspace e+1
      bind=$mod, mouse_up, exec, hyprsome workspace e-1
      bind=$mod SHIFT,right,resizeactive,20 0
      bind=$mod SHIFT,left,resizeactive,-20 0
      bind=$mod SHIFT,up,resizeactive,0 -20
      bind=$mod SHIFT,down,resizeactive,0 20
      bind=$mod SHIFT,R, movetoworkspace,special
      bind=$mod ,R , togglespecialworkspace,

      bindm=$mod, mouse:272, movewindow

      windowrulev2=idleinhibit focus, class:^(mpv|.+exe|celluloid)$
      windowrulev2=idleinhibit focus, title:^(.*YouTube.*)$
      windowrulev2=idleinhibit focus, title:^(.*Twitch.*)$
    '';
  };
}
