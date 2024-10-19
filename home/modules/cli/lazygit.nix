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
      promptToReturnFromSubprocess = true; # display confirmation when subprocess terminates
      keybinding = {
        universal = {
          quit = "q";
          return = "<esc>";
          quitWithoutChangingDirectory = "Q";
          togglePanel = "<tab>";
          prevItem = "w";
          nextItem = "s";
          prevItem-alt = "<disabled>";
          nextItem-alt = "<disabled>";
          prevPage = "W";
          nextPage = "S";
          scrollLeft = "A";
          scrollRight = "D";
          gotoTop = "<";
          gotoBottom = ">";
          toggleRangeSelect = "<disabled>";
          rangeSelectDown = "<disabled>";
          rangeSelectUp = "<disabled>";
          prevBlock = "<disabled>";
          nextBlock = "<disabled>";
          prevBlock-alt = "<disabled>";
          nextBlock-alt = "<disabled>";
          jumpToBlock = ["1" "2" "3" "4" "5"];
          nextMatch = "n";
          prevMatch = "p";
          startSearch = "/";
          optionMenu = "?";
          select = "<space>";
          goInto = "<enter>";
          confirm = "<enter>";
          confirmInEditor = "<a-enter>";
          remove = "k";
          new = "n";
          edit = "e";
          openFile = "o";
          scrollUpMain = "<pgup>";
          scrollDownMain = "<pgdown>";
          executeShellCommand = ":";
          createRebaseOptionsMenu = "m";
          pushFiles = "P";
          pullFiles = "p";
          refresh = "R";
          createPatchOptionsMenu = "<c-p>";
          nextTab = "]";
          prevTab = "[";
          nextScreenMode = "+";
          prevScreenMode = "_";
          undo = "z";
          redo = "<c-z>";
          filteringMenu = "<c-s>";
          diffingMenu = "W";
          diffingMenu-alt = "<c-e>";
          copyToClipboard = "<c-o>";
          openRecentRepos = "<c-r>";
          submitEditorText = "<enter>";
          extrasMenu = "@";
          toggleWhitespaceInDiffView = "<c-w>";
          increaseContextInDiffView = "}";
          decreaseContextInDiffView = "{";
          increaseRenameSimilarityThreshold = ")";
          decreaseRenameSimilarityThreshold = "(";
          openDiffTool = "<c-t>";
        };
        status = {
          checkForUpdate = "u";
          recentRepos = "<enter>";
          allBranchesLogGraph = "h";
        };
        files = {
          commitChanges = "c";
          commitChangesWithoutHook = "w";
          amendLastCommit = "H";
          commitChangesWithEditor = "C";
          findBaseCommitForFixup = "<c-f>";
          confirmDiscard = "x";
          ignoreFile = "i";
          refreshFiles = "r";
          stashAllChanges = "j";
          viewStashOptions = "J";
          toggleStagedAll = "h";
          viewResetOptions = "l";
          fetch = "f";
          toggleTreeView = "`";
          openMergeTool = "M";
          openStatusFilter = "<c-b>";
          copyFileInfoToClipboard = "y";
        };
        branches = {
          createPullRequest = "o";
          viewPullRequestOptions = "O";
          copyPullRequestURL = "<c-y>";
          checkoutBranchByName = "c";
          forceCheckoutBranch = "F";
          rebaseBranch = "r";
          renameBranch = "R";
          mergeIntoCurrentBranch = "M";
          viewGitFlowOptions = "i";
          fastForward = "f";
          createTag = "T";
          pushTag = "P";
          setUpstream = "u";
          fetchRemote = "f";
          sortOrder = "s";
        };
        worktrees = {
          viewWorktreeOptions = "w";
        };
        commits = {
          squashDown = "s";
          renameCommit = "r";
          renameCommitWithEditor = "R";
          viewResetOptions = "g";
          markCommitAsFixup = "f";
          createFixupCommit = "F";
          squashAboveCommits = "S";
          moveDownCommit = "<c-j>";
          moveUpCommit = "<c-k>";
          amendToCommit = "A";
          resetCommitAuthor = "a";
          pickCommit = "p";
          revertCommit = "t";
          cherryPickCopy = "C";
          pasteCommits = "V";
          markCommitAsBaseForRebase = "B";
          tagCommit = "T";
          checkoutCommit = "<space>";
          resetCherryPick = "<c-R>";
          copyCommitAttributeToClipboard = "y";
          openLogMenu = "<c-l>";
          openInBrowser = "o";
          viewBisectOptions = "b";
          startInteractiveRebase = "i";
        };
        amendAttribute = {
          resetAuthor = "a";
          setAuthor = "A";
          addCoAuthor = "c";
        };
        stash = {
          popStash = "g";
          renameStash = "r";
        };
        commitFiles = {
          checkoutCommitFile = "c";
        };
        main = {
          toggleSelectHunk = "a";
          pickBothHunks = "b";
          editSelectHunk = "E";
        };
        submodules = {
          init = "i";
          update = "u";
          bulkMenu = "b";
        };
        commitMessage = {
          commitMenu = "<c-o>";
        };
      };
    };
  };
}
