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
          "bind \"Alt j\"" = {MoveFocus = "Left";};
          "bind \"Alt ;\"" = {MoveFocus = "Right";};
          "bind \"Alt k\"" = {MoveFocus = "Down";};
          "bind \"Alt l\"" = {MoveFocus = "Up";};

          "bind \"Alt m\"" = {Resize = "Increase Left";};
          "bind \"Alt ,\"" = {Resize = "Increase Down";};
          "bind \"Alt .\"" = {Resize = "Increase Up";};
          "bind \"Alt /\"" = {Resize = "Increase Right";};
          "bind \"Alt =\"" = {Resize = "Increase";};
          "bind \"Alt -\"" = {Resize = "Decrease";};

          "bind \"Alt u\"" = {MovePane = "Left";};
          "bind \"Alt i\"" = {MovePane = "Down";};
          "bind \"Alt o\"" = {MovePane = "Up";};
          "bind \"Alt p\"" = {MovePane = "Right";};

          "bind \"Alt w\"" = {GoToTab = 1;};
          "bind \"Alt e\"" = {GoToTab = 2;};
          "bind \"Alt r\"" = {GoToTab = 3;};
          "bind \"Alt s\"" = {GoToTab = 4;};
          "bind \"Alt d\"" = {GoToTab = 5;};
          "bind \"Alt f\"" = {GoToTab = 6;};
          "bind \"Alt x\"" = {GoToTab = 7;};
          "bind \"Alt c\"" = {GoToTab = 8;};
          "bind \"Alt v\"" = {GoToTab = 9;};
          "bind \"Alt g\"" = {GoToTab = 10;};

          "bind \"Alt *\"" = {NewPane = "Down";};
          "bind \"Alt )\"" = {NewPane = "Right";};

          "bind \"Alt }\"" = {MoveTab = "Left";};
          "bind \"Alt <\"" = {MoveTab = "Right";};

          "bind \"Alt n\"" = {NewTab = {name = " ";};};
          "bind \"Alt q\"" = {CloseTab = {};};

          "bind \"Alt a\"" = {CloseFocus = {};};

          "bind \"Alt !\"" = {Detach = {};};
          "bind \"Alt @\"" = {ToggleFloatingPanes = {};};
          "bind \"Alt #\"" = {TogglePaneEmbedOrFloating = {};};
          "bind \"Alt $\"" = {TogglePaneFrames = {};};
          "bind \"Alt %\"" = {ToggleFocusFullscreen = {};};

          "bind \"Alt *\"" = {
            SwitchToMode = "RenameTab";
            TabNameInput = 0;
          };
          "bind \"Alt &\"" = {
            SwitchToMode = "EnterSearch";
            SearchInput = 0;
          };
          "bind \"Alt (\"" = {
            SwitchToMode = "Scroll";
          };
          "bind \"Alt b\"" = {
            SwitchToMode = "Session";
          };
        };
        scroll = {
          "bind \"L\"" = {HalfPageScrollUp = {};};
          "bind \"K\"" = {HalfPageScrollDown = {};};
          "bind \"l\"" = {ScrollUp = {};};
          "bind \"k\"" = {ScrollDown = {};};
          "bind \"Alt *\"" = {
            SwitchToMode = "RenameTab";
            TabNameInput = 0;
          };
          "bind \"Alt &\"" = {
            SwitchToMode = "EnterSearch";
            SearchInput = 0;
          };
          "bind \"Alt (\"" = {
            SwitchToMode = "Normal";
          };
          "bind \"Alt y\"" = {
            SwitchToMode = "Session";
          };
        };
        search = {
          "bind \"K\"" = {HalfPageScrollDown = {};};
          "bind \"L\"" = {HalfPageScrollUp = {};};
          "bind \"l\"" = {Search = "up";};
          "bind \"k\"" = {Search = "down";};
          "bind \"c\"" = {SearchToggleOption = "CaseSensitivity";};
          "bind \"k\"" = {SearchToggleOption = "Wrap";};
          "bind \"o\"" = {SearchToggleOption = "WholeWord";};
          "bind \"Alt *\"" = {
            SwitchToMode = "RenameTab";
            TabNameInput = 0;
          };
          "bind \"Alt &\"" = {
            SwitchToMode = "Normal";
          };
          "bind \"Alt (\"" = {
            SwitchToMode = "Scroll";
          };
        };
        entersearch = {
          "bind \"Esc\"" = {
            SwitchToMode = "Normal";
          };
          "bind \"Alt *\"" = {
            SwitchToMode = "RenameTab";
            TabNameInput = 0;
          };
          "bind \"Alt &\"" = {
            SwitchToMode = "Normal";
          };
          "bind \"Alt (\"" = {
            SwitchToMode = "Scroll";
          };
        };
        renametab = {
          "bind \"Esc\"" = {
            "UndoRenameTab; SwitchToMode" = "Tab";
          };
          "bind \"Alt *\"" = {
            "UndoRenameTab; SwitchToMode" = "Tab";
          };
          "bind \"Alt &\"" = {
            UndoRenameTab = {};
            SwitchToMode = "EnterSearch";
            SearchInput = 0;
          };
          "bind \"Alt (\"" = {
            UndoRenameTab = {};
            SwitchToMode = "Normal";
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
