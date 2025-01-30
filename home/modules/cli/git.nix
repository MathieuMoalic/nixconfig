{...}: {
  home.file.".config/git/allowed_signers".text = ''
    mat ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPcmHHg1pEOAxvEAyr6p5MY0m3/+BOn8nJOcAf7mMaej
  '';
  programs.git = {
    enable = true;
    userName = "Mathieu Moalic";
    userEmail = "matmoa@pm.me";
    extraConfig = {
      init = {defaultBranch = "main";};
      credential = {helper = "store --file ~/.config/git/.git-credentials";};
      commit = {gpgSign = true;};
      tag = {gpgSign = true;};
      pull = {rebase = false;};
      push = {autoSetupRemote = true;};
      gpg = {
        format = "ssh";
        ssh = {
          allowedSignersFile = "~/.config/git/allowed_signers";
        };
      };
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
  programs.nushell.shellAliases = {
    gs = "git status";
    gc = "git commit -S -m";
    ga = "git add";
    gco = "git checkout";
  };
}
