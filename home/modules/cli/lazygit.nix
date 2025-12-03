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
        pagers = [
          {
            colorArg = "always";
            pager = "${pkgs.delta}/bin/delta --dark --paging=never";
          }
        ];
      };
      confirmOnQuit = false;
      quitOnTopLevelReturn = false;
      disableStartupPopups = false;
      notARepository = "quit";
      promptToReturnFromSubprocess = false;
    };
  };
}
