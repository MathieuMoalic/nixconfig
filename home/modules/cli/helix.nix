{config, ...}: {
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
