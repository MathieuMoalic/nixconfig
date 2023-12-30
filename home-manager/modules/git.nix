{...}: {
  programs.git = {
    enable = true;
    userName = "Mathieu Moalic";
    userEmail = "matmoa@pm.me";
    extraConfig = {
      init = {defaultBranch = "main";};
    };
  };
}
