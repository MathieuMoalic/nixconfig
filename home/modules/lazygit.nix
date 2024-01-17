{pkgs, ...}: {
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        windowSize = "normal";
        scrollHeight = 2;
        scrollPastBottom = true;
        scrollOffMargin = 2;
        scrollOffBehavior = "margin";
        sidePanelWidth = 0.3333;
        expandFocusedSidePanel = false;
        mainPanelSplitMode = "flexible";
        enlargedSideViewLocation = "left";
        language = "auto";
        timeFormat = "02 Jan 06";
        shortTimeFormat = "3:04PM";
        theme = {
          activeBorderColor = ["green" "bold"];
          inactiveBorderColor = ["white"];
          searchingActiveBorderColor = ["cyan" "bold"];
          optionsTextColor = ["blue"];
          selectedLineBgColor = ["blue"]; # "default" for no background color
          selectedRangeBgColor = ["blue"];
          cherryPickedCommitBgColor = ["cyan"];
          cherryPickedCommitFgColor = ["blue"];
          unstagedChangesColor = ["red"];
          defaultFgColor = ["default"];
        };
        commitLength = {
          show = true;
        };
        mouseEvents = true;
        skipDiscardChangeWarning = false;
        skipStashWarning = false;
        showFileTree = true;
        showListFooter = true;
        showRandomTip = true;
        showBranchCommitHash = false;
        showBottomLine = false;
        showPanelJumps = true;
        showCommandLog = false;
        nerdFontsVersion = "";
        commandLogSize = 8;
        splitDiff = "auto";
        skipRewordInEditorWarning = false;
        border = "rounded";
        animateExplosion = true;
        portraitMode = "auto";
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "${pkgs.delta}/bin/delta --dark --paging=never";
          useConfig = false;
        };
        commit = {
          signOff = false;
        };
        merging = {
          manualCommit = false;
          args = "";
        };
        log = {
          order = "topo-order";
          showGraph = "when-maximised";
          showWholeGraph = false;
        };
        skipHookPrefix = "WIP";
        mainBranches = ["master" "main"];
        autoFetch = true;
        autoRefresh = true;
        fetchAll = true;
        branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium {{branchName}} --";
        allBranchesLogCmd = "git log --graph --all --color=always --abbrev-commit --decorate --date=relative --pretty=medium";
        overrideGpg = false;
        disableForcePushing = false;
        parseEmoji = false;
      };
      os = {
        copyToClipboardCmd = "";
        editPreset = "";
        edit = "";
        editAtLine = "";
        editAtLineAndWait = "";
        open = "";
        openLink = "";
      };
      refresher = {
        refreshInterval = 10;
        fetchInterval = 60;
      };
      update = {
        method = "prompt";
        days = 14;
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
          prevPage = ",";
          nextPage = ".";
          gotoTop = "<";
          gotoBottom = ">";
          scrollLeft = "A";
          scrollRight = "D";
          prevBlock = "a";
          nextBlock = "d";
          jumpToBlock = ["1" "2" "3" "4" "5"];
          nextMatch = "n";
          prevMatch = "N";
          # optionMenu = "<disabled>";
          optionMenu-alt1 = "?";
          select = "<space>";
          goInto = "<enter>";
          openRecentRepos = "<c-r>";
          confirm = "<enter>";
          remove = "k";
          new = "n";
          edit = "e";
          openFile = "o";
          scrollUpMain = "W";
          scrollDownMain = "S";
          executeCustomCommand = ":";
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
          diffingMenu = "K";
          diffingMenu-alt = "<c-e>";
          copyToClipboard = "<c-o>";
          submitEditorText = "<enter>";
          extrasMenu = "@";
          toggleWhitespaceInDiffView = "<c-K>";
          increaseContextInDiffView = "}";
          decreaseContextInDiffView = "{";
        };
        status = {
          checkForUpdate = "u";
          recentRepos = "<enter>";
        };
        files = {
          commitChanges = "c";
          commitChangesWithoutHook = "k";
          amendLastCommit = "H";
          commitChangesWithEditor = "C";
          findBaseCommitForFixup = "<c-f>";
          confirmDiscard = "x";
          ignoreFile = "i";
          refreshFiles = "r";
          stashAllChanges = "j";
          viewStashOptions = "J";
          toggleStagedAll = "h";
          viewResetOptions = "L";
          fetch = "f";
          toggleTreeView = "`";
          openMergeTool = "M";
          openStatusFilter = "<c-b>";
        };
        branches = {
          createPullRequest = "o";
          viewPullRequestOptions = "O";
          checkoutBranchByName = "c";
          forceCheckoutBranch = "F";
          rebaseBranch = "r";
          renameBranch = "R";
          mergeIntoCurrentBranch = "M";
          viewGitFlowOptions = "i";
          fastForward = "f"; # fast-forward this branch from its upstream
          createTag = "T";
          pushTag = "P";
          setUpstream = "u"; # set as upstream of checked-out branch
          fetchRemote = "f";
        };
        commits = {
          squashDown = "j";
          renameCommit = "r";
          renameCommitWithEditor = "R";
          viewResetOptions = "g";
          markCommitAsFixup = "f";
          createFixupCommit = "F"; # create fixup commit for this commit
          squashAboveCommits = "S";
          moveDownCommit = "<c-j>"; # move commit down one
          moveUpCommit = "<c-k>"; # move commit up one
          amendToCommit = "H";
          pickCommit = "p"; # pick commit (when mid-rebase)
          revertCommit = "t";
          cherryPickCopy = "c";
          cherryPickCopyRange = "C";
          pasteCommits = "v";
          tagCommit = "T";
          checkoutCommit = "<space>";
          resetCherryPick = "<c-R>";
          copyCommitMessageToClipboard = "<c-y>";
          openLogMenu = "<c-l>";
          viewBisectOptions = "b";
        };
        stash = {
          popStash = "g";
          renameStash = "r";
        };
        commitFiles = {
          checkoutCommitFile = "c";
        };
        main = {
          toggleDragSelect = "v";
          toggleDragSelect-alt = "V";
          toggleSelectHunk = "h";
          pickBothHunks = "b";
        };
        submodules = {
          init = "i";
          update = "u";
          bulkMenu = "b";
        };
      };
    };
  };
}
