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
    };
  };
  home.shellAliases = {
    gs = "git status";
    gc = "git commit -S -m";
    ga = "git add";
    gco = "git checkout";
  };
}
