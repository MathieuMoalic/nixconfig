{config, ...}: let
  theme = config.colorScheme.palette;
in {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local act = wezterm.action

      local config = {}

      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      -- Copy last command output (requires OSC 133 semantic zones from the shell)
      wezterm.on("copy-last-output", function(window, pane)
        local zones = pane:get_semantic_zones("Output")
        if not zones or #zones == 0 then
          window:toast_notification(
            "wezterm",
            "No Output zones found. Ensure shell integration/OSC 133 is enabled in your prompt.",
            nil,
            4000
          )
          return
        end

        local last = zones[#zones]
        local text = pane:get_text_from_semantic_zone(last)

        if not text or not text:find("%S") then
          window:toast_notification("wezterm", "Last output was empty.", nil, 2000)
          return
        end

        -- Copies to system clipboard (works on Wayland without wl-copy)
        window:copy_to_clipboard(text, "Clipboard")
        window:toast_notification("wezterm", "Copied last command output to clipboard.", nil, 1500)
      end)

      config.enable_tab_bar = false
      config.font = wezterm.font('FiraCode Nerd Font Mono')
      config.font_size = 13.0
      config.window_background_opacity = 0.95
      config.default_cursor_style = 'BlinkingBar'
      config.cursor_thickness = '2.5px'
      config.enable_wayland = true
      config.window_close_confirmation = 'NeverPrompt'

      config.keys = {
        { key = 'v',         mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
        { key = "Backspace", mods = "CTRL", action = act.SendKey { key = "w", mods = "CTRL" } },
        { key = "o",         mods = "CTRL", action = act.EmitEvent("copy-last-output") },
      }

      config.colors = {
        foreground = '${theme.base05}',
        background = '${theme.base00}',
        cursor_border = '${theme.base05}',
        cursor_bg = '${theme.base05}',
        cursor_fg = '${theme.base00}',
        ansi = {
          '${theme.base00}', '${theme.base08}', '${theme.base0B}', '${theme.base0A}',
          '${theme.base0D}', '${theme.base0E}', '${theme.base0C}', '${theme.base05}',
        },
        brights = {
          '${theme.base03}', '${theme.base09}', '${theme.base01}', '${theme.base02}',
          '${theme.base04}', '${theme.base06}', '${theme.base0F}', '${theme.base07}',
        },
      }

      return config
    '';
  };
}
