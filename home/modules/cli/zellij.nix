{
  config,
  pkgs,
  ...
}:
with config.colorScheme.palette; {
  home.shellAliases = {
    tl = "zellij ls";
    ta = "zellij a -c";
    tk = "zellij d --force";
    tka = "zellij da -y --force";
  };
  home.file.".config/zellij/plugins/monocle.wasm".source = pkgs.fetchurl {
    url = "https://github.com/imsnif/monocle/releases/download/v0.100.0/monocle.wasm";
    sha256 = "sha256-MxS5OBEUdrcuRfvewLt+q24lb8J+3O4/yjbgMD6nnqQ=";
  };

  home.file.".config/zellij/plugins/zjstatus.wasm".source = pkgs.fetchurl {
    url = "https://github.com/dj95/zjstatus/releases/download/v0.17.0/zjstatus.wasm";
    sha256 = "sha256-IgTfSl24Eap+0zhfiwTvmdVy/dryPxfEF7LhVNVXe+U=";
  };

  home.file.".config/zellij/layouts/default.kdl".text = let
    background = base00;
    tab = base05;
    tab-active = base0E;
  in ''
    layout {
        default_tab_template{
            pane split_direction="vertical" {
                pane
            }
            pane size=1 borderless=true {
                plugin location="file:~/.config/zellij/plugins/zjstatus.wasm" {
                    format_left  "{tabs}"
                    format_right ""
                    format_space "#[bg=#${background}ff]"
                    hide_frame_for_single_pane "false"
                    mode_normal  ""
                    tab_normal "#[fg=#${background},bg=#${tab}]#[fg=#${background},bold,bg=#${tab}] {index} {name} #[fg=#${tab},bg=#${background}ff]"
                    tab_active "#[fg=#${background},bg=#${tab-active}]#[fg=#${background},bold,bg=#${tab-active}] {index} {name} #[fg=#${tab-active},bg=#${background}ff]"
                }
            }
        }
        tab name=" "
    }
  '';

  programs.zellij = {
    enable = true;
    settings = {
      theme = "mydracula";
      on_force_close = "detach";
      simplified_ui = false;
      default_shell = "zsh";
      pane_frames = true;
      auto_layout = true;
      default_mode = "normal";
      mouse_mode = true;
      scroll_buffer_size = 10000;
      copy_clipboard = "system";
      copy_on_select = true;
      scrollback_editor = "$EDITOR";
      mirror_session = false;
      ui = {
        pane_frames = {
          hide_session_name = true;
          rounded_corners = true;
        };
      };
      styled_underlines = true;
      session_serialization = true;
      pane_viewport_serialization = true;
      scrollback_lines_to_serialize = 500;
      keybinds = {
        "normal clear-defaults=true" = {
          "bind \"Alt F\"" = {
            "LaunchPlugin \"file:~/.config/zellij/plugins/monocle.wasm\"" = {
              in_place = true;
              kiosk = true;
            };
          };
          "bind \"Alt i\"" = {Detach = {};};
          "bind \"Alt p\"" = {ToggleFloatingPanes = {};};
          "bind \"Alt P\"" = {TogglePaneEmbedOrFloating = {};};
          "bind \"Alt o\"" = {TogglePaneFrames = {};};
          "bind \"Alt h\"" = {NewPane = "Down";};
          "bind \"Alt v\"" = {NewPane = "Right";};
          "bind \"Alt ,\"" = {CloseFocus = {};};
          "bind \"Alt f\"" = {ToggleFocusFullscreen = {};};
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
          "bind \"Alt n\"" = {NewTab = {name = " ";};};
          "bind \"Alt k\"" = {CloseTab = {};};
          "bind \"Alt 1\"" = {GoToTab = 1;};
          "bind \"Alt 2\"" = {GoToTab = 2;};
          "bind \"Alt 3\"" = {GoToTab = 3;};
          "bind \"Alt 4\"" = {GoToTab = 4;};
          "bind \"Alt 5\"" = {GoToTab = 5;};
          "bind \"Alt 6\"" = {GoToTab = 6;};
          "bind \"Alt 7\"" = {GoToTab = 7;};
          "bind \"Alt 8\"" = {GoToTab = 8;};
          "bind \"Alt 9\"" = {GoToTab = 9;};
          "bind \"Alt 0\"" = {GoToTab = 10;};
          "bind \"Alt r\"" = {
            SwitchToMode = "RenameTab";
            TabNameInput = 0;
          };
          "bind \"Alt e\"" = {
            SwitchToMode = "EnterSearch";
            SearchInput = 0;
          };
          "bind \"Alt q\"" = {
            SwitchToMode = "Scroll";
          };
          "bind \"Alt y\"" = {
            SwitchToMode = "Session";
          };
        };
        scroll = {
          "bind \"W\"" = {HalfPageScrollUp = {};};
          "bind \"S\"" = {HalfPageScrollDown = {};};
          "bind \"w\"" = {ScrollUp = {};};
          "bind \"s\"" = {ScrollDown = {};};
          "bind \"Alt r\"" = {
            SwitchToMode = "RenameTab";
            TabNameInput = 0;
          };
          "bind \"Alt e\"" = {
            SwitchToMode = "EnterSearch";
            SearchInput = 0;
          };
          "bind \"Alt q\"" = {
            SwitchToMode = "Normal";
          };
          "bind \"Alt y\"" = {
            SwitchToMode = "Session";
          };
        };
        search = {
          "bind \"s\"" = {HalfPageScrollDown = {};};
          "bind \"w\"" = {HalfPageScrollUp = {};};
          "bind \"a\"" = {Search = "up";};
          "bind \"d\"" = {Search = "down";};
          "bind \"c\"" = {SearchToggleOption = "CaseSensitivity";};
          "bind \"k\"" = {SearchToggleOption = "Wrap";};
          "bind \"o\"" = {SearchToggleOption = "WholeWord";};
          "bind \"Alt r\"" = {
            SwitchToMode = "RenameTab";
            TabNameInput = 0;
          };
          "bind \"Alt e\"" = {
            SwitchToMode = "Normal";
          };
          "bind \"Alt q\"" = {
            SwitchToMode = "Search";
          };
        };
        entersearch = {
          "bind \"Ctrl c\"" = {
            SwitchToMode = "Scroll";
          };
          "bind \"Esc\"" = {
            SwitchToMode = "Scroll";
          };
          "bind \"Alt r\"" = {
            SwitchToMode = "RenameTab";
            TabNameInput = 0;
          };
          "bind \"Alt e\"" = {
            SwitchToMode = "Normal";
          };
          "bind \"Alt q\"" = {
            SwitchToMode = "Scroll";
          };
        };
        renametab = {
          "bind \"Esc\"" = {
            "UndoRenameTab; SwitchToMode" = "Tab";
          };
          "bind \"Alt r\"" = {
            "UndoRenameTab; SwitchToMode" = "Tab";
          };
          "bind \"Alt e\"" = {
            UndoRenameTab = {};
            SwitchToMode = "EnterSearch";
            SearchInput = 0;
          };
          "bind \"Alt q\"" = {
            UndoRenameTab = {};
            SwitchToMode = "Scroll";
          };
        };
      };
      plugins = {
        "tab-bar" = {path = "tab-bar";};
        "status-bar" = {path = "status-bar";};
        "strider" = {path = "strider";};
        "compact-bar" = {path = "compact-bar";};
      };
      themes = {
        mydracula = {
          fg = "#${base05}";
          bg = "#${zellij-highlight}";
          black = "#${zellij-highlight}";
          red = "#${base08}";
          green = "#${base0B}";
          yellow = "#${base0A}";
          blue = "#${base03}";
          magenta = "#${base0E}";
          cyan = "#${base0C}";
          white = "#${base07}";
          orange = "#${orange}";
        };
      };
    };
  };
}
