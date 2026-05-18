{
  flake.homeModules.mangohud = {
    config,
    pkgs,
    ...
  }: {
    programs.mangohud = {
      enable = false;

      # Set to true if you want MangoHud enabled for all supported apps.
      # Otherwise, use `mangohud %command%` in Steam launch options.
      enableSessionWide = false;

      settings = {
        fps_limit = 0;
        vsync = 1; # MangoHud docs: vsync values are -1/default, 0 adaptive, 1 off, 2 mailbox, 3 on
        position = "top-left";
        font_size = 22;
        round_corners = 8;
        background_alpha = 0.45;
        text_outline = true;
        legacy_layout = false;
        # Hide by default; press toggle_hud to show
        no_display = false;

        ################
        # Main metrics
        ################
        #
        # gpu_stats = true;
        # gpu_temp = true;
        # gpu_core_clock = true;
        # gpu_mem_clock = true;
        # gpu_power = true;
        # gpu_load_change = true;
        # gpu_load_value = [60 90];
        # gpu_load_color = ["39F900" "FDFD09" "B22222"];
        #
        # cpu_stats = true;
        # cpu_temp = true;
        # cpu_power = true;
        # cpu_mhz = true;
        # cpu_load_change = true;
        # cpu_load_value = [60 90];
        # cpu_load_color = ["39F900" "FDFD09" "B22222"];
        #
        # vram = true;
        # ram = true;
        # swap = false;

        fps = true;
        # frametime = true;
        # frame_timing = true;
        # fps_color_change = true;
        # fps_value = [30 60];
        # fps_color = ["B22222" "FDFD09" "39F900"];

        # toggle_hud = "Shift_R+F12";
        # toggle_hud_position = "Shift_R+F11";
        # toggle_fps_limit = "Shift_L+F1";
        # toggle_logging = "Shift_L+F2";
        reload_cfg = "Shift_L+F4";
      };
    };
  };
}
