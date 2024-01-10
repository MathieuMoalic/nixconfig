{config, ...}: {
  programs.zellij = with config.colorScheme.colors; {
    enable = true;
    # enableZshIntegration = true;
    settings = {
      keybinds = {
        clear-defaults = true;
        normal = {
          "bind \"Alt h\"" = {NewPane = "Down";};
          "bind \"Alt v\"" = {NewPane = "Right";};
          "bind \"Alt ,\"" = {CloseFocus = [];};
          "bind \"Alt r\"" = {
            SwitchToMode = "RenameTab";
            TabNameInput = 0;
          };
          "bind \"Alt f\"" = {ToggleFocusFullscreen = [];};

          "bind \"Alt a\"" = {MoveFocus = "Left";};
          "bind \"Alt d\"" = {MoveFocus = "Right";};
          "bind \"Alt s\"" = {MoveFocus = "Down";};
          "bind \"Alt w\"" = {MoveFocus = "Up";};

          "bind \"Alt A\"" = {Resize = "Increase Left";};
          "bind \"Alt S\"" = {Resize = "Increase Down";};
          "bind \"Alt W\"" = {Resize = "Increase Up";};
          "bind \"Alt D\"" = {Resize = "Increase Right";};
          "bind \"Alt =\"" = {Resize = "Increase";};
          "bind \"Alt -\"" = {Resize = "Decrease";};

          "bind \"Alt Left\"" = {MovePane = "Left";};
          "bind \"Alt Down\"" = {MovePane = "Down";};
          "bind \"Alt Up\"" = {MovePane = "Up";};
          "bind \"Alt Right\"" = {MovePane = "Right";};

          "bind \"Alt n\"" = {NewTab = [];};
          "bind \"Alt k\"" = {CloseTab = [];};
          "bind \"Alt 1\"" = {GoToTab = 1;};
          "bind \"Alt 2\"" = {GoToTab = 2;};
        };
      };

      plugins = {
        "tab-bar" = {path = "tab-bar";};
        "status-bar" = {path = "status-bar";};
        strider = {path = "strider";};
        "compact-bar" = {path = "compact-bar";};
      };

      themes.mydracula = {
        fg = "#${base05}";
        bg = "#${base00}";
        black = "#44465B";
        red = "#${base08}";
        green = "#${base0B}";
        yellow = "#${base0A}";
        blue = "#${base03}";
        magenta = "#${base0E}";
        cyan = "#${base0C}";
        white = "#${base07}";
        orange = "#${orange}";
      };

      theme = "mydracula";
      on_force_close = "detach";
      simplified_ui = false;
      default_shell = "zsh";
      pane_frames = true;
      auto_layout = true;
      default_layout = "compact";
      default_mode = "normal";
      mouse_mode = true;
      scroll_buffer_size = 10000;
      copy_clipboard = "system";
      copy_on_select = true;
      scrollback_editor = "$EDITOR";
      mirror_session = false;
    };
  };
}
