{pkgs, ...}: {
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        package = pkgs.nvim-unstable;
        viAlias = false;
        vimAlias = true;
        lsp = {
          enable = true;
          formatOnSave = true;
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

            "<leader>b" = "Last buffer";
            "<leader>w" = "Write";
            "<leader>q" = "Quit";
            "<leader>c" = "Crates";
            "<leader>ct" = "Toggle hints";
            "<leader>cr" = "Reload data";
            "<leader>cv" = "Show versions";
            "<leader>cf" = "Show features";
            "<leader>cd" = "Show dependencies";
            "<leader>cu" = "Update crate";
            "<leader>ca" = "Update all";
            "<leader>cU" = "Upgrade crate";
            "<leader>cA" = "Upgrade all";
            "<leader>cx" = "Expand to inline table";
            "<leader>cX" = "Extract to table";
            "<leader>cH" = "Open homepage";
            "<leader>cR" = "Open repository";
            "<leader>cD" = "Open documentation";
            "<leader>cC" = "Open crates.io";
            "<leader>cL" = "Open lib.rs";
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
          {
            key = "<leader>ct";
            mode = ["n"];
            action = ":lua require('crates').toggle()<CR>";
            silent = true;
          }
          {
            key = "<leader>cr";
            mode = ["n"];
            action = ":lua require('crates').reload()<CR>";
            silent = true;
          }

          {
            key = "<leader>cv";
            mode = ["n"];
            action = ":lua require('crates').show_versions_popup()<CR>";
            silent = true;
          }
          {
            key = "<leader>cf";
            mode = ["n"];
            action = ":lua require('crates').show_features_popup()<CR>";
            silent = true;
          }
          {
            key = "<leader>cd";
            mode = ["n"];
            action = ":lua require('crates').show_dependencies_popup()<CR>";
            silent = true;
          }

          {
            key = "<leader>cu";
            mode = ["n"];
            action = ":lua require('crates').update_crate()<CR>";
            silent = true;
          }
          {
            key = "<leader>cu";
            mode = ["v"];
            action = ":lua require('crates').update_crates()<CR>";
            silent = true;
          }
          {
            key = "<leader>ca";
            mode = ["n"];
            action = ":lua require('crates').update_all_crates()<CR>";
            silent = true;
          }
          {
            key = "<leader>cU";
            mode = ["n"];
            action = ":lua require('crates').upgrade_crate()<CR>";
            silent = true;
          }
          {
            key = "<leader>cU";
            mode = ["v"];
            action = ":lua require('crates').upgrade_crates()<CR>";
            silent = true;
          }
          {
            key = "<leader>cA";
            mode = ["n"];
            action = ":lua require('crates').upgrade_all_crates()<CR>";
            silent = true;
          }

          {
            key = "<leader>cx";
            mode = ["n"];
            action = ":lua require('crates').expand_plain_crate_to_inline_table()<CR>";
            silent = true;
          }
          {
            key = "<leader>cX";
            mode = ["n"];
            action = ":lua require('crates').extract_crate_into_table()<CR>";
            silent = true;
          }

          {
            key = "<leader>cH";
            mode = ["n"];
            action = ":lua require('crates').open_homepage()<CR>";
            silent = true;
          }
          {
            key = "<leader>cR";
            mode = ["n"];
            action = ":lua require('crates').open_repository()<CR>";
            silent = true;
          }
          {
            key = "<leader>cD";
            mode = ["n"];
            action = ":lua require('crates').open_documentation()<CR>";
            silent = true;
          }
          {
            key = "<leader>cC";
            mode = ["n"];
            action = ":lua require('crates').open_crates_io()<CR>";
            silent = true;
          }
          {
            key = "<leader>cL";
            mode = ["n"];
            action = ":lua require('crates').open_lib_rs()<CR>";
            silent = true;
          }
        ];
        languages = {
          enableTreesitter = true;
          enableFormat = true;
          enableExtraDiagnostics = true;

          python.enable = true;
          rust = {
            enable = true;
            crates.enable = true;
          };
          nix.enable = true;

          bash.enable = true;
          svelte.enable = true;
          tailwind.enable = true;
          ts.enable = true;
        };
      };
    };
  };
}
