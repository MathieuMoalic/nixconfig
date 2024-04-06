{...}: {
  programs.git = {
    enable = true;
    userName = "Mathieu Moalic";
    userEmail = "matmoa@pm.me";
    extraConfig = {
      init = {defaultBranch = "main";};
      credential = {helper = "store --file ~/.config/git/.git-credentials";};
      pull = {rebase = false;};
      push = {autoSetupRemote = true;};
      gpg = {format = "ssh";};
      user = {signingkey = "~/.ssh/id_ed25519.pub";};
      core = {pager = "delta";};
      interactive = {diffFilter = "delta --color-only";};
      delta = {
        navigate = true;
        dark = true;
      };
      merge = {conflictstyle = "diff3";};
      diff = {colorMoved = "default";};
    };
  };
  home.shellAliases = {
    gs = "git status";
    gc = "git commit -S -m";
    ga = "git add";
    gco = "git checkout";
  };
}
