{
  flake.homeModules.helix = {
    pkgs,
    lib,
    ...
  }: {
    programs.helix = {
      enable = true;
      package = pkgs.helix;
      defaultEditor = false;

      extraPackages = with pkgs; [
        nil
        alejandra

        ruff
        ty

        rust-analyzer
        gopls
        bash-language-server
        shfmt
        yaml-language-server
        yamlfmt
        marksman

        tinymist
        typstyle
      ];

      settings = {
        theme = "dracula-transparent";

        editor = {
          scrolloff = 20;
          mouse = true;
          cursorline = true;
          true-color = true;
          auto-format = true;
          popup-border = "all";
          bufferline = "multiple";

          lsp = {
            enable = true;
            display-messages = true;
            display-inlay-hints = false;
          };

          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };

          statusline = {
            left = [
              "mode"
              "spinner"
              "file-name"
              "read-only-indicator"
              "file-modification-indicator"
            ];

            center = [];

            right = [
              "diagnostics"
              "workspace-diagnostics"
              "selections"
              "position"
              "file-encoding"
              "file-type"
            ];

            separator = "│";

            diagnostics = [
              "warning"
              "error"
            ];

            workspace-diagnostics = [
              "warning"
              "error"
            ];

            mode = {
              normal = "NORMAL";
              insert = "INSERT";
              select = "SELECT";
            };
          };
        };

        keys = {
          normal.space = {
            w = ":write";
            q = ":quit";
            d = "buffer_picker";
            b = "goto_previous_buffer";
            a = "code_action";
            h = "hover";
            n = "goto_next_diag";

            y = "yank_to_clipboard";
          };

          select.space = {
            a = "code_action";
            y = "yank_to_clipboard";
            Y = "yank_to_clipboard";
          };
        };
      };

      languages = {
        language-server = {
          nil = {
            command = lib.getExe pkgs.nil;

            config.nil.nix = {
              autoArchive = false;
              flake.autoArchive = true;
            };
          };

          ruff = {
            command = lib.getExe pkgs.ruff;
            args = ["server"];
          };

          ty = {
            command = lib.getExe pkgs.ty;
            args = ["server"];
          };

          tinymist = {
            command = lib.getExe pkgs.tinymist;
          };
        };

        language = [
          {
            name = "python";

            roots = [
              "pyproject.toml"
              "setup.py"
              ".git"
            ];

            auto-format = true;

            language-servers = [
              "ty"
              {
                name = "ruff";
                only-features = [
                  "diagnostics"
                  "code-action"
                ];
              }
            ];

            formatter = {
              command = lib.getExe pkgs.ruff;

              args = [
                "format"
                "--stdin-filename"
                "%{buffer_name}"
                "--quiet"
                "-"
              ];
            };
          }

          {
            name = "nix";

            roots = [
              "flake.nix"
              "shell.nix"
              ".git"
            ];

            auto-format = true;
            language-servers = ["nil"];

            formatter.command = lib.getExe pkgs.alejandra;
          }

          {
            name = "typst";

            auto-format = true;
            language-servers = ["tinymist"];

            formatter.command = lib.getExe pkgs.typstyle;
          }
        ];
      };

      themes.dracula-transparent = {
        inherits = "dracula";
        "ui.background" = {};
      };

      ignores = [];
    };
  };
}
