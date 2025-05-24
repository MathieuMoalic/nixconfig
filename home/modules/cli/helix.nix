{config, ...}: let
in {
  programs.helix = {
    defaultEditor = false;
    enable = true;
    settings = {
      theme = "mytheme";
      editor = {
        auto-completion = true;
        completion-trigger-len = 2;
        auto-format = true;
        auto-info = true;
        auto-pairs = true;
        bufferline = "multiple";
        cursorline = true;
        gutters = ["diagnostics" "line-numbers"];
        idle-timeout = 400;
        line-number = "relative";
        middle-click-paste = true;
        mouse = true;
        rulers = [];
        scroll-lines = 3;
        scrolloff = 90;
        true-color = true;
        statusline = {
          center = ["file-name"];
          left = ["mode" "spinner" "version-control"];
          right = [
            "diagnostics"
            "selections"
            "position"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];
          separator = "│";
        };
        lsp = {
          "auto-signature-help" = true;
          "display-messages" = true;
          "display-signature-help-docs" = true;
        };
        "cursor-shape" = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        "file-picker" = {
          "git-exclude" = true;
          "git-global" = true;
          "git-ignore" = true;
          hidden = false;
          ignore = true;
          "max-depth" = 10;
          parents = true;
        };
        search = {
          "smart-case" = true;
          "wrap-around" = true;
        };
        whitespace = {render = "none";};
        "indent-guides" = {
          character = "|";
          render = true;
        };
        "soft-wrap" = {enable = true;};
      };
      # keys.normal = {
      #   E = "goto_line_end";
      #   F = "find_prev_char";
      #   G = "goto_line";
      #   Q = "goto_line_start";
      #   S = "half_page_down";
      #   T = "till_prev_char";
      #   W = "half_page_up";
      #   Z = "move_next_long_word_end";
      #   a = "move_char_left";
      #   d = "move_char_right";
      #   e = "move_next_word_start";
      #   f = "find_next_char";
      #   q = "move_prev_word_start";
      #   s = "move_line_down";
      #   t = "find_till_char";
      #   w = "move_line_up";
      #   z = "move_next_word_end";
      #   "+" = "increment";
      #   C = "change_selection_noyank";
      #   I = "insert_at_line_start";
      #   K = "delete_selection_noyank";
      #   L = "insert_at_line_end";
      #   O = "open_above";
      #   P = "paste_before";
      #   R = "replace_with_yanked";
      #   U = "redo";
      #   c = "change_selection";
      #   i = "insert_mode";
      #   k = "delete_selection";
      #   l = "append_mode";
      #   minus = "decrement";
      #   o = "open_below";
      #   p = "paste_after";
      #   r = "replace";
      #   u = "undo";
      #   y = "yank";
      #   "~" = "switch_case";
      #   H = "split_selection";
      #   h = "select_regex";
      #   C-f = "file_picker";
      #   C-q = ["insert_mode" ":q!"];
      #   # C-space = ["insert_mode" ":q!"];
      #   C-s = ":w!";
      #   C-O = ":config-reload";
      #   C-o = ["insert_mode" ":o"];
      #   S-ret = ["open_above" "normal_mode"];
      #   ret = ["open_below" "normal_mode"];
      #   v = "select_mode";
      #   # macros
      #   m = "replay_macro";
      #   M = "record_macro";
      #   # buffers
      #   D = "goto_next_buffer";
      #   A = "goto_previous_buffer";
      #   C-w = ":buffer-close";
      #   C-g = ":sh zellij run -f -x 10% -y 10% --width 80% --height 80% -- ${yaziPicker}/bin/yazi-picker";
      #   # v	Enter select (extend) mode	select_mode
      #   # g	Enter goto mode	N/A
      #   # m	Enter match mode	N/A
      #   # :	Enter command mode	command_mode
      #   # z	Enter view mode	N/A
      #   # Z	Enter sticky view mode	N/A
      #   # Ctrl-w	Enter window mode	N/A
      #   # Space	Enter space mode	N/A
      # };
      # # match mode
      # keys.normal.j = {
      #   m = "match_brackets";
      #   a = "surround_add";
      #   r = "surround_replace";
      #   k = "surround_delete";
      #   f = "select_textobject_around";
      #   t = "select_textobject_inner";
      # };
      # # window mode
      # keys.normal.J = {
      #   r = "rotate_view";
      #   v = "vsplit";
      #   h = "hsplit";
      #   f = "goto_file";
      #   F = "goto_file";
      #   a = "jump_view_left";
      #   s = "jump_view_down";
      #   w = "jump_view_up";
      #   d = "jump_view_right";
      #   q = "wclose";
      #   # close all other windows
      #   o = "wonly";
      #   A = "swap_view_left";
      #   S = "swap_view_down";
      #   W = "swap_view_up";
      #   D = "swap_view_right";
      # };
      # # space mode
      # keys.normal.space = {
      #   f = "file_picker";
      #   F = "file_picker_in_current_directory";
      #   b = "buffer_picker";
      #   j = "jumplist_picker";
      #   k = "hover";
      #   s = "symbol_picker";
      #   S = "workspace_symbol_picker";
      #   d = "diagnostics_picker";
      #   D = "workspace_diagnostics_picker";
      #   r = "rename_symbol";
      #   a = "code_action";
      #   h = "select_references_to_symbol_under_cursor";
      #   "'" = "last_picker";
      #   p = "paste_clipboard_after";
      #   P = "paste_clipboard_before";
      #   y = "yank_to_clipboard";
      #   Y = "yank_main_selection_to_clipboard";
      #   R = "replace_selections_with_clipboard";
      #   "/" = "global_search";
      #   "?" = "command_palette";
      # };
      # keys.normal."[" = {
      #   d = "goto_prev_diag";
      #   D = "goto_first_diag";
      #   f = "goto_prev_function";
      #   t = "goto_prev_class";
      #   a = "goto_prev_parameter";
      #   c = "goto_prev_comment";
      #   T = "goto_prev_test";
      #   p = "goto_prev_paragraph";
      #   g = "goto_prev_change";
      #   G = "goto_first_change";
      #   space = "add_newline_above";
      # };

      # keys.normal."]" = {
      #   d = "goto_next_diag";
      #   D = "goto_last_diag";
      #   f = "goto_next_function";
      #   t = "goto_next_class";
      #   a = "goto_next_parameter";
      #   c = "goto_next_comment";
      #   T = "goto_next_test";
      #   p = "goto_next_paragraph";
      #   g = "goto_next_change";
      #   G = "goto_last_change";
      #   space = "add_newline_below";
      # };

      # keys.insert = {
      #   C-f = "file_picker";
      #   C-a = "move_char_left";
      #   C-d = "move_char_right";
      #   C-r = "insert_register";
      #   C-s = "normal_mode";
      #   C-w = "completion";
      #   C-q = ":q!";
      #   C-space = ":q!";
      # };
      # keys.select = {
      #   C-q = ":q!";
      #   C-space = ":q!";
      #   C-f = "file_picker";
      #   C-s = "normal_mode";
      #   E = "extend_next_long_word_start";
      #   F = "find_prev_char";
      #   G = "goto_line";
      #   Q = "extend_prev_long_word_start";
      #   S = "half_page_down";
      #   T = "till_prev_char";
      #   W = "half_page_up";
      #   Z = "extend_next_long_word_end";
      #   a = "extend_char_left";
      #   d = "extend_char_right";
      #   e = "extend_next_word_start";
      #   f = "find_next_char";
      #   q = "extend_prev_word_start";
      #   s = "extend_line_down";
      #   t = "find_till_char";
      #   w = "extend_line_up";
      #   z = "extend_next_word_end";
      #   k = "delete_selection";
      # };
    };
    themes = let
      c = config.colorScheme.palette;
    in {
      mytheme = let
        foreground = "#${c.base05}";
        background = "#${c.base00}";
        cursorline = "#${c.hx-cursor-line}";
        darker = "#${c.hx-darker}";
        black = "#${c.hx-black}";
        grey = "#${c.hx-grey}";
        comment = "#${c.base03}";
        current_line = "#${c.hx-current-line}";
        selection = "#${c.hx-selection}";
        red = "#${c.base08}";
        orange = "#${c.orange}";
        yellow = "#${c.base0A}";
        green = "#${c.base0B}";
        cyan = "#${c.base0C}";
        purple = "#${c.base0D}";
        pink = "#${c.base0E}";
      in {
        "annotation" = {fg = foreground;};
        "attribute" = {
          fg = green;
          modifiers = ["italic"];
        };
        "comment" = {fg = comment;};
        "constant" = {fg = purple;};
        "constant.numeric" = {fg = purple;};
        "constant.character.escape" = {fg = pink;};
        "constructor" = {fg = purple;};
        "function" = {fg = green;};
        "keyword" = {fg = pink;};
        "keyword.storage.type" = {
          fg = cyan;
          modifiers = ["italic"];
        };
        "label" = {fg = cyan;};
        "string" = {fg = yellow;};
        "string.special" = {fg = orange;};
        "type" = {
          fg = cyan;
          modifiers = ["italic"];
        };
        "variable.builtin" = {
          fg = purple;
          modifiers = ["italic"];
        };
        "variable.parameter" = {
          fg = orange;
          modifiers = ["italic"];
        };
        "diff.plus" = {fg = green;};
        "diff.minus" = {fg = red;};
        "ui.background" = {
          fg = foreground;
          bg = background;
        };
        "ui.cursor.match" = {
          fg = foreground;
          bg = grey;
        };
        "ui.cursor" = {
          fg = background;
          bg = purple;
          modifiers = ["dim"];
        };
        "ui.cursorline.primary" = {bg = cursorline;};
        "ui.statusline" = {
          fg = foreground;
          bg = darker;
        };
        "ui.menu" = {
          fg = foreground;
          bg = current_line;
        };
        "ui.selection.primary" = {bg = current_line;};
        "ui.selection" = {bg = selection;};
        "diagnostic" = {
          underline = {
            color = orange;
            style = "curl";
          };
        };
        "diagnostic.hint" = {
          underline = {
            color = purple;
            style = "curl";
          };
        };
        "diagnostic.warning" = {
          underline = {
            color = yellow;
            style = "curl";
          };
        };
        "diagnostic.error" = {
          underline = {
            color = red;
            style = "curl";
          };
        };
        "info" = {fg = cyan;};
        "error" = {fg = red;};
        "warning" = {fg = yellow;};
        "hint" = {fg = purple;};
        "ui.help" = {
          fg = foreground;
          bg = black;
        };
        "ui.text" = {fg = foreground;};
        "ui.window" = {fg = foreground;};
        "ui.virtual.whitespace" = {fg = current_line;};
      };
    };
    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          scope = "source.nix";
          injection-regex = "nix";
          file-types = ["nix"];
          shebangs = [];
          comment-token = "#";
          language-servers = ["nixd"];
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          formatter = {
            command = "alejandra";
            args = ["-q"];
          };
        }
        {
          name = "python";
          auto-format = true;
          language-servers = ["ruff-lsp"];
          roots = ["pyproject.toml"];
        }
      ];
    };
  };
}
