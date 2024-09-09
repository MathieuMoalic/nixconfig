{...}: {
  # It doesn't work but it's a good example
  programs.rbw = {
    enable = true;
    settings = {
      email = "matmoa@pm.me";
      base_url = "https://vw.matmoa.xyz";
      identity_url = "https://vw.matmoa.xyz/identity";
    };
  };
}
