{
  pkgs,
  lib,
  ...
}: {
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        luaConfigRC = {
          "mx3-go-colors" = {
            after = [];
            before = [];
            data = ''
              vim.filetype.add({extension = { mx3 = "mx3" }})
              pcall(function()
                vim.treesitter.language.register("go", "mx3")
              end)
            '';
          };
          "typst-preview-open-cmd" = {
            before = [];
            after = [];
            data = ''
              require('typst-preview').setup({
                open_cmd = '${lib.getExe pkgs.brave} %s',
              })
            '';
          };
        };

        lsp = {
          enable = true;
          inlayHints.enable = false;
          formatOnSave = true;
          lspkind.enable = true;

          servers = {
            "*" = {
              root_markers = [".git"];
              capabilities = {
                textDocument = {
                  semanticTokens = {
                    multilineTokenSupport = true;
                  };
                };
              };
            };

            nil.settings.nil.nix = {
              autoArchive = false;
              flake = {
                autoArchive = true;
              };
            };

            ruff = {
              cmd = [(lib.getExe pkgs.ruff) "server"];
              root_markers = [".git" "pyproject.toml" "setup.py"];
              filetypes = ["python"];
            };

            pyright = {
              cmd = ["${pkgs.pyright}/bin/pyright-langserver" "--stdio"];
              root_markers = [".git" "pyproject.toml" "setup.py"];
              filetypes = ["python"];
            };

            ty = {
              cmd = [(lib.getExe pkgs.ty) "server"];
              root_markers = [".git" "pyproject.toml" "setup.py"];
              filetypes = ["python"];
            };
          };

          mappings = {
            previousDiagnostic = "[d";
            nextDiagnostic = "]d";
          };
        };

        languages = {
          enableFormat = true;
          enableExtraDiagnostics = false;
          enableTreesitter = true;

          python = {
            enable = true;
            lsp.enable = false;
            format.type = ["ruff"];
          };

          rust.enable = true;
          nix.enable = true;
          bash.enable = true;
          dart.enable = true;
          typst.enable = true;
          yaml.enable = true;
          go.enable = true;
          markdown.enable = true;
        };

        extraPackages = [pkgs.pyright pkgs.ruff pkgs.ty];

        utility = {
          surround.enable = true;
          ccc.enable = true;
          direnv.enable = true;
          mkdir.enable = true;
          sleuth.enable = true;
        };
        globals.clipboard = "osc52";

        viAlias = false;
        vimAlias = true;

        options = {
          cursorlineopt = "both";
          tabstop = 2;
          scrolloff = 20;
          mouse = "nvi";
          hlsearch = false;
          incsearch = true;
        };
        assistant.copilot = {
          cmp.enable = true;
        };
        theme = {
          enable = true;
          style = "dark";
          name = "dracula";
          transparent = true;
        };
        statusline.lualine = {
          enable = true;
          theme = "dracula";
          activeSection.x = [
            ''
              {
                -- Lsp server name
                function()
                  local buf_ft = vim.bo.filetype
                  local excluded_buf_ft = { toggleterm = true, NvimTree = true, ["neo-tree"] = true, TelescopePrompt = true }

                  if excluded_buf_ft[buf_ft] then
                    return ""
                    end

                  local bufnr = vim.api.nvim_get_current_buf()
                  local clients = vim.lsp.get_clients({ bufnr = bufnr })

                  if vim.tbl_isempty(clients) then
                    return "No Active LSP"
                  end

                  local active_clients = {}
                  for _, client in ipairs(clients) do
                    table.insert(active_clients, client.name)
                  end

                  return table.concat(active_clients, ", ")
                end,
                icon = ' ',
                separator = {left = ''},
              }
            ''
            ''
              {
                "diagnostics",
                sources = {'nvim_diagnostic'},
                symbols = {error = '󰅙  ', warn = '  ', info = '  ', hint = '󰌵 '},
                colored = true,
                update_in_insert = false,
                always_visible = false,
                diagnostics_color = {
                  color_error = { fg = 'red' },
                  color_warn = { fg = 'yellow' },
                  color_info = { fg = 'cyan' },
                },
              }
            ''
          ];
        };
        telescope.enable = true;
        utility.yazi-nvim = {
          enable = true;
          mappings = {
            openYazi = "<leader>s";
            openYaziDir = "gyd";
          };
          setupOpts = {
            open_for_directories = true;
            keymaps = false;
          };
        };
        autocomplete.nvim-cmp = {
          enable = true;
          # this actually pulls in the path completion source
          sourcePlugins = [
            "cmp-path" # file path completion
            "cmp-nvim-lsp" # LSP completion (nice to have)
            "cmp-buffer" # words from current buffer
            "cmp-luasnip" # snippets, if you use them
          ];

          sources = {
            path = "[Path]";
            buffer = "[Buffer]";
            nvim_lsp = "[LSP]";
            luasnip = "[Snip]";
          };
        };
        binds.whichKey = {
          enable = true;
          register = {
            "<leader>l" = "LSP";
            "<leader>s" = "Yazi";
            "<leader>b" = "Last buffer";
            "<leader>w" = "Write";
            "<leader>q" = "Quit";
            "<leader>a" = "Code actions";
            "<leader>h" = "LSP Hints";
            "<leader>y" = "Yank buffer";
            "<leader>n" = "Next diagnostic";

            "<leader>t" = "Typst";
            "<leader>tc" = "Toggle Follow Cursor";
            "<leader>tp" = "Pin Main Document to Current";
            "<leader>tt" = "Toggle Preview";

            "[" = "Previous …";
            "]" = "Next …";

            "[a" = "Previous arglist file";
            "[A" = "First arglist file (rewind)";
            "[b" = "Previous buffer";
            "[B" = "First buffer (rewind)";

            "[d" = "Prev diagnostic in buffer";
            "[D" = "First diagnostic in buffer";

            "[l" = "Prev location-list entry";
            "[L" = "First location-list entry";

            "[m" = "Prev method start";
            "[M" = "Prev method end";

            "[q" = "Prev quickfix entry";
            "[Q" = "First quickfix entry";

            "[s" = "Prev misspelled word";

            "[t" = "Prev tag";
            "[T" = "First tag";

            "[%" = "Prev unmatched group";
            "[(" = "Prev (";
            "[<" = "Prev <";
            "[{" = "Prev {";

            "[<C-l>" = "Prev location-list file (:lpfile)";
            "[<C-q>" = "Prev quickfix file (:cpfile)";
            "[<C-t>" = "Prev tag in preview (:ptprevious)";

            "]a" = "Next arglist file";
            "]A" = "Last arglist file (last)";
            "]b" = "Next buffer";
            "]B" = "Last buffer (blast)";

            "]d" = "Next diagnostic in buffer";
            "]D" = "Last diagnostic in buffer";

            "]l" = "Next location-list entry";
            "]L" = "Last location-list entry";

            "]m" = "Next method start";
            "]M" = "Next method end";

            "]q" = "Next quickfix entry";
            "]Q" = "Last quickfix entry";

            "]s" = "Next misspelled word";

            "]t" = "Next tag";
            "]T" = "Last tag";

            "]%" = "Next unmatched group";
            "])" = "Next )";
            "]>" = "Next >";
            "]}" = "Next }";

            "]<C-l>" = "Next location-list file (:lnfile)";
            "]<C-q>" = "Next quickfix file (:cnfile)";
            "]<C-t>" = "Next tag in preview (:ptnext)";
          };
          setupOpts = {
            notify = true;
            preset = "modern";
            win = {
              border = "rounded";
            };
          };
        };

        ui.borders.plugins.which-key = {
          enable = true;
          style = "rounded";
        };
        keymaps = [
          {
            key = "<leader>c";
            mode = ["n" "v" "x"];
            action = "<Nop>";
            silent = true;
            noremap = true;
          }
          {
            key = "<leader>n";
            mode = ["n"];
            action = ":lua vim.diagnostic.goto_next()<CR>";
            silent = true;
          }
          {
            key = "<leader>a";
            mode = ["n" "v"];
            action = ":lua vim.lsp.buf.code_action()<CR>";
            silent = true;
          }
          {
            key = "<leader>h";
            mode = ["n"];
            action = ":lua vim.lsp.buf.hover()<CR>";
            silent = true;
          }
          {
            key = "<leader>tt";
            mode = ["n"];
            silent = true;
            action = ":TypstPreviewToggle<CR>";
          }
          {
            key = "<leader>tc";
            mode = ["n"];
            silent = true;
            action = ":TypstPreviewFollowCursorToggle<CR>";
          }
          {
            key = "<leader>tp";
            mode = ["n"];
            silent = true;
            action = ":lua vim.lsp.buf_request(0, 'workspace/executeCommand', { command = 'tinymist.pinMain', arguments = { vim.api.nvim_buf_get_name(0) } }, function() end)<CR>";
          }
          {
            key = "<leader>y";
            mode = ["n"];
            silent = true;
            action = ":silent %y +<CR>";
          }
          {
            key = "<leader>y";
            mode = ["x"];
            silent = true;
            action = "\"+y";
          }
          {
            key = "<leader>Y";
            mode = ["x"];
            silent = true;
            action = "\"+y";
          }
          {
            key = "jk";
            mode = ["i"];
            silent = true;
            action = "<Esc>";
          }
          {
            key = "<leader>d";
            mode = ["n"];
            silent = true;
            action = ":Telescope buffers<CR>";
          }
          {
            key = "<leader>q";
            mode = ["n"];
            silent = true;
            action = ":q<CR>";
          }
          {
            key = "<leader>b";
            mode = ["n"];
            silent = true;
            action = "<C-^>";
          }
          {
            key = "<leader>w";
            mode = ["n"];
            silent = true;
            action = ":w<CR>";
          }
        ];
      };
    };
  };
}
