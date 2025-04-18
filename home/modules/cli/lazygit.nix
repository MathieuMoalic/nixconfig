{pkgs, ...}: {
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        timeFormat = "02 Jan 06";
        shortTimeFormat = "13:04";
        showRandomTip = false;
        showBottomLine = false;
        showPanelJumps = true;
        showCommandLog = false;
        nerdFontsVersion = "3";
        animateExplosion = true;
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "${pkgs.delta}/bin/delta --dark --paging=never";
        };
      };
      confirmOnQuit = false;
      quitOnTopLevelReturn = false;
      disableStartupPopups = false;
      notARepository = "quit"; # one of: 'prompt' | 'create' | 'skip' | 'quit'
      promptToReturnFromSubprocess = false; # display confirmation when subprocess terminates
    };
  };
}
