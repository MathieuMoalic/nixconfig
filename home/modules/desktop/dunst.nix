{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.settings.exec-once = lib.mkAfter ["${pkgs.dunst}/bin/dunst"];
  services.dunst = with config.colorScheme.palette; {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = 300;
        height = 300;
        origin = "top-right";
        offset = "10x50";
        scale = 0;
        notification_limit = 0;
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        indicate_hidden = true;
        transparency = 0;
        separator_height = 1;
        padding = 8;
        horizontal_padding = 10;
        text_icon_padding = 0;
        frame_width = 1;
        background = "#${base00}";
        foreground = "#${base03}";
        frame_color = "#${base03}";
        separator_color = "frame";
        sort = true;
        idle_threshold = 0;
        font = "FiraCode Nerd Font 14";
        line_height = 0;
        markup = "full";
        format = "%s %p\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 64;
        icon_path = "/usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/";
        sticky_history = true;
        history_length = 20;
        dmenu = "/usr/bin/dmenu -p dunst:";
        browser = "/usr/bin/firefox -new-tab";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 0;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
        timeout = 10;
      };
    };
  };
}
