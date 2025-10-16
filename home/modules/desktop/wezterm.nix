{config, ...}: let
  theme = config.colorScheme.palette;
in {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = {}

      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      config.enable_tab_bar = false
      config.font = wezterm.font('FiraCode Nerd Font Mono')
      config.font_size = 13.0
      config.window_background_opacity = 0.95
      config.default_cursor_style = 'BlinkingBar'
      config.cursor_thickness = '2.5px'
      config.enable_wayland = true
      config.window_close_confirmation = 'NeverPrompt'
      config.keys = {
        {key = 'v', mods = 'CTRL',  action = wezterm.action.PasteFrom 'Clipboard'},
        {key="Backspace", mods="CTRL", action=wezterm.action.SendKey{key="w", mods="CTRL"}},
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
