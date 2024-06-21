{...}: {
  programs.zellij.enable = true;

  home.shellAliases = {
    tl = "zellij ls";
    ta = "zellij a -c";
    tk = "zellij k";
  };

  xdg.configFile."zellij/config.kdl".text = ''
      keybinds {
        normal clear-defaults=true  {
            bind "Alt i" { Detach; }
            bind "Alt p" { ToggleFloatingPanes; }
            bind "Alt P" { TogglePaneEmbedOrFloating; }
            bind "Alt o" { TogglePaneFrames; }

            bind "Alt h" { NewPane "Down"; }
            bind "Alt v" { NewPane "Right"; }
            bind "Alt ," { CloseFocus; }
            bind "Alt f" { ToggleFocusFullscreen; }

            bind "Alt a" { MoveFocus "Left"; }
            bind "Alt d" { MoveFocus "Right"; }
            bind "Alt s" { MoveFocus "Down"; }
            bind "Alt w" { MoveFocus "Up"; }

            bind "Alt A" { Resize "Increase Left"; }
            bind "Alt S" { Resize "Increase Down"; }
            bind "Alt W" { Resize "Increase Up"; }
            bind "Alt D" { Resize "Increase Right"; }
            bind "Alt =" { Resize "Increase"; }
            bind "Alt -" { Resize "Decrease"; }

            bind "Alt Left" { MovePane "Left"; }
            bind "Alt Down" { MovePane "Down"; }
            bind "Alt Up" { MovePane "Up"; }
            bind "Alt Right" { MovePane "Right"; }

            bind "Alt n" { NewTab; }
            bind "Alt k" { CloseTab; }
            bind "Alt 1" { GoToTab 1; }
            bind "Alt 2" { GoToTab 2; }
            bind "Alt 3" { GoToTab 3; }
            bind "Alt 4" { GoToTab 4; }
            bind "Alt 5" { GoToTab 5; }
            bind "Alt 6" { GoToTab 6; }
            bind "Alt 7" { GoToTab 7; }
            bind "Alt 8" { GoToTab 8; }
            bind "Alt 9" { GoToTab 9; }

            bind "Alt r" { SwitchToMode "RenameTab"; TabNameInput 0; }
            bind "Alt e" { SwitchToMode "EnterSearch"; SearchInput 0; }
            bind "Alt q" { SwitchToMode "Scroll"; }
            bind "Alt y" { SwitchToMode "Session"; }
        }
        scroll {
            bind "W" { HalfPageScrollUp; }
            bind "S" { HalfPageScrollDown; }
            bind "w" { ScrollUp; }
            bind "s" { ScrollDown; }
            bind "Alt r" { SwitchToMode "RenameTab"; TabNameInput 0; }
            bind "Alt e" { SwitchToMode "EnterSearch"; SearchInput 0; }
            bind "Alt q" { SwitchToMode "Normal"; }
        }
        search {
            bind "s" { HalfPageScrollDown; }
            bind "w" { HalfPageScrollUp; }
            bind "a" { Search "up"; }
            bind "d" { Search "down"; }
            bind "c" { SearchToggleOption "CaseSensitivity"; }
            bind "k" { SearchToggleOption "Wrap"; }
            bind "o" { SearchToggleOption "WholeWord"; }
            bind "Alt r" { SwitchToMode "RenameTab"; TabNameInput 0; }
            bind "Alt e" { SwitchToMode "Normal"; }
            bind "Alt q" { SwitchToMode "Search"; }
        }
        entersearch {
            bind "Ctrl c" "Esc" { SwitchToMode "Scroll"; }
            bind "Alt r" { SwitchToMode "RenameTab"; TabNameInput 0; }
            bind "Alt e" { SwitchToMode "Normal"; }
            bind "Alt q" { SwitchToMode "Scroll"; }
        }
        renametab {
            bind "Esc" "Alt r" { UndoRenameTab; SwitchToMode "Tab"; }
            bind "Alt e" { UndoRenameTab; SwitchToMode "EnterSearch"; SearchInput 0; }
            bind "Alt q" { UndoRenameTab; SwitchToMode "Scroll"; }
        }
    }

    plugins {
        tab-bar { path "tab-bar"; }
        status-bar { path "status-bar"; }
        strider { path "strider"; }
        compact-bar { path "compact-bar"; }
    }

    themes {
       mydracula {
            fg 248 248 242
            bg 68 71 90
            black 68 70 91
            red 255 85 85
            green 80 250 123
            yellow 241 250 140
            blue 98 114 164
            magenta 255 121 198
            cyan 139 233 253
            white 255 255 255
            orange 255 184 108
        }
    }

    theme "mydracula"
    on_force_close "detach"
    simplified_ui false
    default_shell "zsh"
    pane_frames true
    auto_layout true
    default_layout "compact"
    default_mode "normal"
    mouse_mode true
    scroll_buffer_size 10000
    copy_clipboard "system"
    copy_on_select true
    scrollback_editor "$EDITOR"
    mirror_session false
    ui {
    pane_frames {
        hide_session_name true
        rounded_corners true
        }
    }
    auto_layout true
    styled_underlines true
    session_serialization true
    pane_viewport_serialization true
    scrollback_lines_to_serialize 500
  '';
  # programs.zellij = with config.colorScheme.colors; {
  #   enable = true;
  #   enableZshIntegration = true;
  #   settings = {
  #     keybinds = {
  #       normal = {
  #         # clear-defaults = true;

  #         "bind \"Alt h\"" = {NewPane = "Down";};
  #         "bind \"Alt v\"" = {NewPane = "Right";};
  #         "bind \"Alt ,\"" = {CloseFocus = [];};
  #         "bind \"Alt r\"" = {
  #           SwitchToMode = "RenameTab";
  #           TabNameInput = 0;
  #         };
  #         "bind \"Alt f\"" = {ToggleFocusFullscreen = [];};

  #         "bind \"Alt a\"" = {MoveFocus = "Left";};
  #         "bind \"Alt d\"" = {MoveFocus = "Right";};
  #         "bind \"Alt s\"" = {MoveFocus = "Down";};
  #         "bind \"Alt w\"" = {MoveFocus = "Up";};

  #         "bind \"Alt A\"" = {Resize = "Increase Left";};
  #         "bind \"Alt S\"" = {Resize = "Increase Down";};
  #         "bind \"Alt W\"" = {Resize = "Increase Up";};
  #         "bind \"Alt D\"" = {Resize = "Increase Right";};
  #         "bind \"Alt =\"" = {Resize = "Increase";};
  #         "bind \"Alt -\"" = {Resize = "Decrease";};

  #         "bind \"Alt Left\"" = {MovePane = "Left";};
  #         "bind \"Alt Down\"" = {MovePane = "Down";};
  #         "bind \"Alt Up\"" = {MovePane = "Up";};
  #         "bind \"Alt Right\"" = {MovePane = "Right";};

  #         "bind \"Alt n\"" = {NewTab = [];};
  #         "bind \"Alt k\"" = {CloseTab = [];};
  #         "bind \"Alt 1\"" = {GoToTab = 1;};
  #         "bind \"Alt 2\"" = {GoToTab = 2;};
  #       };
  #     };

  #     plugins = {
  #       "tab-bar" = {path = "tab-bar";};
  #       "status-bar" = {path = "status-bar";};
  #       strider = {path = "strider";};
  #       "compact-bar" = {path = "compact-bar";};
  #     };

  #     themes.mydracula = {
  #       fg = "#${base05}";
  #       bg = "#${base00}";
  #       black = "#44465B";
  #       red = "#${base08}";
  #       green = "#${base0B}";
  #       yellow = "#${base0A}";
  #       blue = "#${base03}";
  #       magenta = "#${base0E}";
  #       cyan = "#${base0C}";
  #       white = "#${base07}";
  #       orange = "#${orange}";
  #     };

  #     theme = "mydracula";
  #     on_force_close = "detach";
  #     simplified_ui = false;
  #     default_shell = "zsh";
  #     pane_frames = true;
  #     auto_layout = true;
  #     default_layout = "compact";
  #     default_mode = "normal";
  #     mouse_mode = true;
  #     scroll_buffer_size = 10000;
  #     copy_clipboard = "system";
  #     copy_on_select = true;
  #     scrollback_editor = "$EDITOR";
  #     mirror_session = false;
  #   };
  # };
}
