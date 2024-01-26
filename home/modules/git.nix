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
    };
  };
}
