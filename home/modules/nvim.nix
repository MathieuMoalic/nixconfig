{inputs, ...}: {
  imports = [
    inputs.nvf.homeManagerModules.default
  ];
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
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
        };
        assistant.copilot = {
          cmp.enable = true;
        };
        filetree.neo-tree.enable = true;
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
        autocomplete.nvim-cmp.enable = true;
        keymaps = [
          {
            key = "jk";
            mode = ["i"];
            silent = true;
            action = "<Esc>";
          }
          {
            key = "<leader>ff"; # The key combination
            mode = ["n"]; # Normal mode
            silent = true; # Do not show command output
            action = ":Telescope find_files<CR>"; # Action to open Telescope file search
          }
        ];
        languages = {
          enableLSP = true;
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
          nu.enable = true;
        };
      };
    };
  };
}
