{pkgs, ...}: {
  # zoxide, skim shell integration maybe?
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
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
      stty -ixon # allows ctrl + q and s
      autoload -U edit-command-line
      zle -N edit-command-line

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
    sessionVariables = {
      EDITOR = "${pkgs.helix}/bin/hx";
      VISUAL = "$EDITOR";
      SUDO_EDIT = "$EDITOR";
      ERRFILE = "$XDG_CACHE_HOME/X11/xsession-errors";
      ZDOTDIR = "$HOME/.config/zsh";
      USERXSESSION = "$XDG_CACHE_HOME/X11/xsession";
      USERXSESSIONRC = "$XDG_CACHE_HOME/X11/xsessionrc";
      ALTUSERXSESSION = "$XDG_CACHE_HOME/X11/Xsession";
      GNUPGHOME = "$XDG_DATA_HOME/gnupg";
      GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
      JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
      LESSHISTFILE = "$XDG_CACHE_HOME/less/history";
      _Z_DATA = "$XDG_DATA_HOME/z";
      ZSH_COMPDUMP = "$ZSH/cache/.zcompdump-$HOST";
      RUSTUP_HOME = "$XDG_DATA_HOME/rust";
      CARGO_HOME = "$XDG_DATA_HOME/cargo";
      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      GOPATH = "$XDG_DATA_HOME/go";
    };
    shellAliases = {
      rl = "exec zsh -l";
      rm = " rm -vdrf";
      cp = "cp -r";
      mkdir = " mkdir -p";
      l = "exa -ahlg --across --icons -s age";
      lt = "l --tree";
      e = "$EDITOR";
      m = "amumax";
      op = "xdg-open";
      se = "sudoedit";
      tl = "zellij ls";
      ta = "zellij a -c";
      tk = "zellij k";
      # wget="wget --hsts-file="$XDG_DATA_HOME/wget-hsts""";
      rs = "rsync -rv";
      pm = "podman";
      cat = "bat -Pp";
      pmps = "pm ps -a --format \"table {{.Names}} {{.Status}} {{.Created}} {{.Image}}\"";
      sysu = "systemctl --user";
      cd = "z";
      d = "z";
      tldr = "tldr -q";
      zfn2 = "ssh zfn2 -o RequestTTY=yes -o RemoteCommand=\"zellij a -c 1\"";
      homeserver = "TERM=xterm-256color ssh homeserver -o RequestTTY=yes -o RemoteCommand=\"zellij a -c 1\"";
      pcss = "ssh pcss -o RequestTTY=yes -o RemoteCommand=\"zellij a -c 1\"";
      fixcursor = "echo \"\e[5 q\"";
      fpi = "flatpak --user install -y --or-update";
      fpr = "flatpak --user run";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      myip = "curl ifconfig.me";
      dev = "nix develop -c zsh";
      gs = "git status";
      gc = "git commit -m";
      ga = "git add";
      gco = "git checkout";
      ghs = "gh copilot suggest -t shell";
      ghe = "gh copilot explain";
      ghc = "gh copilot";
      hup = "cd $HOME/nix && git add . && home-manager switch --flake '/home/mat/nix#mat@xps' && cd -";
      up = "cd $HOME/nix && git add . && sudo nixos-rebuild switch --flake '/home/mat/nix#xps' && cd -";
      colors = "curl -Ls 'https://raw.githubusercontent.com/NNBnh/textart-collections/main/color/colortest.textart' | bash; echo";
      p = "nix-shell -p";
    };
  };
}
