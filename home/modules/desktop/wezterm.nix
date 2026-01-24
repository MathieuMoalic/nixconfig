{config, ...}: let
  theme = config.colorScheme.palette;
in {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      if set -q WEZTERM_PANE
        function __wezterm_set_user_var --argument-names name value
          set -l b64 (printf '%s' "$value" | base64 | tr -d '\n')
          printf '\e]1337;SetUserVar=%s=%s\a' "$name" "$b64"
        end

        function __wezterm_set_prog --on-event fish_preexec
          __wezterm_set_user_var WEZTERM_PROG "$argv[1]"
        end
      end
    '';
  };

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local act = wezterm.action

      local config = {}
      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      local function copy_last_command_and_output(window, pane)
        local outputs = pane:get_semantic_zones("Output") or {}
        if #outputs == 0 then
          window:toast_notification(
            "wezterm",
            "No Output zones found. Ensure shell integration/OSC 133 is enabled in your prompt.",
            nil,
            4000
          )
          return
        end

        local last_out = outputs[#outputs]
        local out_text = pane:get_text_from_semantic_zone(last_out) or ""

        local cmd_text = ""
        local inputs = pane:get_semantic_zones("Input") or {}
        if #inputs > 0 then
          local cmd_zone = nil
          for i = #inputs, 1, -1 do
            local z = inputs[i]
            local z_end_y = z.end_y or 0
            local z_end_x = z.end_x or 0
            local out_start_y = last_out.start_y or 0
            local out_start_x = last_out.start_x or 0

            local ends_before_output =
              (z_end_y < out_start_y) or
              (z_end_y == out_start_y and z_end_x <= out_start_x)

            if ends_before_output then
              cmd_zone = z
              break
            end
          end

          if cmd_zone then
            cmd_text = pane:get_text_from_semantic_zone(cmd_zone) or ""
          end
        end

        if not cmd_text:find("%S") then
          local vars = pane:get_user_vars() or {}
          if vars.WEZTERM_PROG and vars.WEZTERM_PROG:find("%S") then
            cmd_text = vars.WEZTERM_PROG
          end
        end

        cmd_text = (cmd_text or ""):gsub("\r", ""):gsub("\n+$", "")
        out_text = (out_text or ""):gsub("\r", ""):gsub("\n+$", "")

        if (cmd_text .. out_text):match("^%s*$") then
          window:toast_notification("wezterm", "Last command/output was empty.", nil, 2000)
          return
        end

        local combined
        if cmd_text ~= "" and out_text ~= "" then
          combined = cmd_text .. "\n" .. out_text
        else
          combined = (cmd_text ~= "" and cmd_text) or out_text
        end

        window:copy_to_clipboard(combined, "Clipboard")
        window:toast_notification("wezterm", "Copied last command + output to clipboard.", nil, 1500)
      end

      wezterm.on("copy-last-command-and-output", copy_last_command_and_output)
      wezterm.on("copy-last-output", copy_last_command_and_output)

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
        { key = "o",         mods = "CTRL", action = act.EmitEvent("copy-last-command-and-output") },
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
