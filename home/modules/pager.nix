{pkgs, ...}: {
  # bat will read the keybinds in .config/lesskey
  programs.less = {
    enable = true;
    keys = ''
      s        forw-line
      S        forw-scroll
      w        back-line
      W        back-scroll
      q        quit
      /        forw-search
      f        forw-search
      ^f       forw-search
      ?        back-search
      n        repeat-search
      p        reverse-search
      #stop
    '';
  };
}
