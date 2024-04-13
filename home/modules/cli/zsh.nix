{pkgs, ...}: {
  # zoxide, skim shell integration maybe?
  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    enableVteIntegration = true;
    autocd = true;
    syntaxHighlighting = {
      enable = true;
    };
    historySubstringSearch = {
      enable = true;
      searchUpKey = "^W";
      searchDownKey = "^S";
    };
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.7.0";
          sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
        };
      }
      {
        name = "zsh-sudo";
        file = "zsh-sudo.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "none9632";
          repo = "zsh-sudo";
          rev = "56e830956b88e32cbb7dfe8a3821cb56747e79d0";
          sha256 = "0km9vd033l6qr6dxq33rngmkgir3pzsmd58m0z23z42dpvl0j6xg";
        };
      }
    ];
    initExtra = ''
      WORDCHARS='_-*?[]~&.;!#$%^(){}<>'
      HISTFILE="$XDG_CACHE_HOME/.zhistory"
      # export PATH="$HOME/.local/share/pyvenv/bin":$PATH
      stty -ixon # allows ctrl + q and s
      autoload -U edit-command-line
      zle -N edit-command-line
      export DIRENV_LOG_FORMAT=

      bindkey -rp \'\'
      bindkey " " magic-space
      bindkey "!" self-insert
      bindkey "!-~" self-insert
      bindkey -R "\""-"~" self-insert
      bindkey -R "\M-^@"-"\M-^?" self-insert

      bindkey '^R' _atuin_search_widget

      bindkey "^[[H" beginning-of-line
      bindkey "^[[F" end-of-line
      bindkey "^A" backward-char
      bindkey "^Q" backward-word
      bindkey "^D" forward-char
      bindkey "^E" forward-word

      bindkey "^H" backward-kill-word # this is backspace
      bindkey "^?" backward-delete-char
      bindkey "^[[3;5~" kill-word
      bindkey "^[[3~" delete-char

      bindkey "^K" clear-screen
      bindkey "^M" accept-line # this is enter
      bindkey "^[[27;5;13~" autosuggest-execute # this is ctrl+enter
      bindkey "^T" edit-command-line
      bindkey "^I" expand-or-complete # this is tab
      bindkey "^U" kill-whole-line
      bindkey "^O" which-command
      bindkey "^Z" undo
      bindkey "^P" push-line
      bindkey '^X' sudo-command-line
      bindkey "^[[200~" bracketed-paste

      bindkey -s "^L" 'l^M'
      bindkey -s "^B" 'yazi^M'

    '';
  };
}
