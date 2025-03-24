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
        theme = {
          enable = true;
          style = "dark";
          name = "dracula";
          transparent = true;
        };
        languages = {
          python = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
          };
        };
        statusline.lualine = {
          enable = true;
          theme = "dracula";
        };
      };
    };
  };
}
