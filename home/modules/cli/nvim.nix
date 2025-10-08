{...}: {
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        globals.clipboard = "osc52";
        languages = {
          enableFormat = true;
          enableExtraDiagnostics = true;
          enableTreesitter = true;

          python.enable = true;
          rust.enable = true;
          nix.enable = true;
          bash.enable = true;
          dart.enable = true;
          typst.enable = true;
        };
        viAlias = false;
        vimAlias = true;
        lsp = {
          enable = true;
          formatOnSave = true;
          servers.rust-analyzer = {
            enable = true;
            settings."rust-analyzer" = {
              cargo = {allFeatures = true;};
              check = {command = "clippy";};
              procMacro = {enable = true;};
            };
          };
        };
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
        };
        telescope.enable = true;
        utility.yazi-nvim = {
          enable = true;
          mappings.openYazi = "<leader>s";
          setupOpts.open_for_directories = true;
        };
        autocomplete.nvim-cmp.enable = true;
        binds.whichKey = {
          enable = true;
          register = {
            "<leader>l" = "LSP";
            "<leader>s" = "Yazi";
            "<leader>t" = "Typst";

            "<leader>b" = "Last buffer";
            "<leader>w" = "Write";
            "<leader>q" = "Quit";
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
            key = "<leader>Y";
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
