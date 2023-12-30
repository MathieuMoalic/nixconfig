{
  config,
  pkgs,
  ...
}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      manager = {
        layout = [1 4 3];
        linemode = "size";
        showHidden = true;
        showSymlink = true;
        sortBy = "modified";
        sortDirFirst = false;
        sortReverse = true;
        sortSensitive = true;
      };

      preview = {
        cacheDir = "";
        maxHeight = 900;
        maxWidth = 600;
        tabSize = 2;
        ueberzugOffset = [0 0 0 0];
        ueberzugScale = 1;
      };

      opener = {
        edit = [
          {
            exec = "\$EDITOR \"$@\"";
            block = true;
            for = "unix";
          }
        ];
        extract = [
          {
            exec = "nar \"$1\"";
            desc = "Extract here";
            for = "unix";
          }
        ];
        open = [
          {
            exec = "dg-open \"$@\"";
            desc = "Open";
            for = "linux";
          }
          {
            exec = "pen \"$@\"";
            desc = "Open";
            for = "macos";
          }
        ];
        play = [
          {
            exec = "pv \"$@\"";
            orphan = true;
            for = "unix";
          }
          {
            exec = "ediainfo \"$1\"; echo \"Press enter to exit\"; read";
            block = true;
            desc = "Show media info";
            for = "unix";
          }
        ];
        reveal = [
          {
            exec = "pen -R \"$1\"";
            desc = "Reveal";
            for = "macos";
          }
          {
            exec = "xiftool \"$1\"; echo \"Press enter to exit\"; read";
            block = true;
            desc = "Show EXIF";
            for = "unix";
          }
        ];
      };

      open = {
        rules = [
          {
            name = "*/";
            use = ["edit" "open" "reveal"];
          }
          {
            mime = "text/*";
            use = ["edit" "reveal"];
          }
          {
            mime = "image/*";
            use = ["open" "reveal"];
          }
          {
            mime = "video/*";
            use = ["play" "reveal"];
          }
          {
            mime = "audio/*";
            use = ["play" "reveal"];
          }
          {
            mime = "inode/x-empty";
            use = ["edit" "reveal"];
          }
          {
            mime = "application/json";
            use = ["edit" "reveal"];
          }
          {
            mime = "*/javascript";
            use = ["edit" "reveal"];
          }
          {
            mime = "application/zip";
            use = ["extract" "reveal"];
          }
          {
            mime = "application/gzip";
            use = ["extract" "reveal"];
          }
          {
            mime = "application/x-tar";
            use = ["extract" "reveal"];
          }
          {
            mime = "application/x-bzip";
            use = ["extract" "reveal"];
          }
          {
            mime = "application/x-bzip2";
            use = ["extract" "reveal"];
          }
          {
            mime = "application/x-7z-compressed";
            use = ["extract" "reveal"];
          }
          {
            mime = "application/x-rar";
            use = ["extract" "reveal"];
          }
          {
            mime = "*";
            use = ["open" "reveal"];
          }
        ];
      };

      tasks = {
        bizarreRetry = 5;
        imageAlloc = 536870912; # 512MB
        imageBound = [0 0];
        macroWorkers = 10;
        microWorkers = 5;
        suppressPreload = false;
      };

      plugins = {
        preload = [];
      };

      input = {
        # cd
        cdOffset = [0 2 50 3];
        cdOrigin = "top-center";
        cdTitle = "Change directory:";

        # create
        createOffset = [0 2 50 3];
        createOrigin = "top-center";
        createTitle = "Create:";

        # rename
        renameOffset = [0 1 50 3];
        renameOrigin = "hovered";
        renameTitle = "Rename:";

        # trash
        trashOffset = [0 2 50 3];
        trashOrigin = "top-center";
        trashTitle = "Move {n} selected file{s} to trash? (y/N)";

        # delete
        deleteOffset = [0 2 50 3];
        deleteOrigin = "top-center";
        deleteTitle = "Delete {n} selected file{s} permanently? (y/N)";

        # find
        findOffset = [0 2 50 3];
        findOrigin = "top-center";
        findTitle = ["Find next:" "Find previous:"];

        # search
        searchOffset = [0 2 50 3];
        searchOrigin = "top-center";
        searchTitle = "Search:";

        # shell
        shellOffset = [0 2 50 3];
        shellOrigin = "top-center";
        shellTitle = ["Shell:" "Shell (block):"];

        # overwrite
        overwriteOffset = [0 2 50 3];
        overwriteOrigin = "top-center";
        overwriteTitle = "Overwrite an existing file? (y/N)";

        # quit
        quitOffset = [0 2 50 3];
        quitOrigin = "top-center";
        quitTitle = "{n} task{s} running, sure to quit? (y/N)";
      };

      select = {
        openOffset = [0 1 50 7];
        openOrigin = "hovered";
        openTitle = "Open with:";
      };

      log = {
        enabled = false;
      };
    };
    theme = {
      manager = {
        cwd = {fg = "cyan";};

        hovered = {
          fg = "black";
          bg = "lightblue";
        };
        previewHovered = {underline = true;};

        findKeyword = {
          fg = "yellow";
          italic = true;
        };
        findPosition = {
          fg = "magenta";
          bg = "reset";
          italic = true;
        };

        markerCopied = {
          fg = "lightyellow";
          bg = "lightyellow";
        };
        markerCut = {
          fg = "lightred";
          bg = "lightred";
        };
        markerSelected = {
          fg = "lightgreen";
          bg = "lightgreen";
        };

        tabActive = {
          fg = "black";
          bg = "lightblue";
        };
        tabInactive = {
          fg = "white";
          bg = "darkgray";
        };
        tabWidth = 1;

        borderStyle = {fg = "gray";};
        borderSymbol = "│";

        folderOffset = [1 0 1 0];
        previewOffset = [1 1 1 1];

        syntectTheme = "";
      };

      status = {
        separatorClose = "";
        separatorOpen = "";
        separatorStyle = {
          fg = "darkgray";
          bg = "darkgray";
        };

        modeNormal = {
          fg = "black";
          bg = "lightblue";
          bold = true;
        };
        modeSelect = {
          fg = "black";
          bg = "lightgreen";
          bold = true;
        };
        modeUnset = {
          fg = "black";
          bg = "lightmagenta";
          bold = true;
        };

        progressError = {
          fg = "red";
          bg = "black";
        };
        progressLabel = {bold = true;};
        progressNormal = {
          fg = "blue";
          bg = "black";
        };

        permissionsR = {fg = "lightyellow";};
        permissionsS = {fg = "darkgray";};
        permissionsT = {fg = "lightgreen";};
        permissionsW = {fg = "lightred";};
        permissionsX = {fg = "lightcyan";};
      };
      select = {
        active = {fg = "magenta";};
        border = {fg = "blue";};
        inactive = {};
      };

      input = {
        border = {fg = "blue";};
        selected = {reversed = true;};
        title = {};
        value = {};
      };

      completion = {
        active = {bg = "darkgray";};
        border = {fg = "blue";};
        inactive = {};
        iconCommand = "";
        iconFile = "";
        iconFolder = "";
      };
      tasks = {
        border = {fg = "blue";};
        hovered = {underline = true;};
        title = {};
      };

      which = {
        cand = {fg = "lightcyan";};
        desc = {fg = "magenta";};
        mask = {bg = "black";};
        rest = {fg = "darkgray";};
        separator = "  ";
        separatorStyle = {fg = "darkgray";};
      };

      help = {
        desc = {fg = "gray";};
        exec = {fg = "cyan";};
        footer = {
          fg = "black";
          bg = "white";
        };
        hovered = {
          bg = "darkgray";
          bold = true;
        };
        on = {fg = "magenta";};
      };

      filetype = {
        rules = [
          {
            mime = "image/*";
            fg = "cyan";
          }
          {
            mime = "video/*";
            fg = "yellow";
          }
          {
            mime = "audio/*";
            fg = "yellow";
          }
          {
            mime = "application/zip";
            fg = "magenta";
          }
          {
            mime = "application/gzip";
            fg = "magenta";
          }
          {
            mime = "application/x-tar";
            fg = "magenta";
          }
          {
            mime = "application/x-bzip";
            fg = "magenta";
          }
          {
            mime = "application/x-bzip2";
            fg = "magenta";
          }
          {
            mime = "application/x-7z-compressed";
            fg = "magenta";
          }
          {
            mime = "application/x-rar";
            fg = "magenta";
          }
          {
            mime = "application/xz";
            fg = "magenta";
          }
          {
            mime = "application/doc";
            fg = "green";
          }
          {
            mime = "application/pdf";
            fg = "green";
          }
          {
            mime = "application/rtf";
            fg = "green";
          }
          {
            mime = "application/vnd.*";
            fg = "green";
          }
          {
            name = "*/";
            fg = "blue";
          }
        ];
      };
      icons = {
        ".config/" = "";
        "Desktop/" = "";
        "Development/" = "";
        "Documents/" = "";
        "Downloads/" = "";
        "Library/" = "";
        "Movies/" = "";
        "Music/" = "";
        "Pictures/" = "";
        "Public/" = "";
        "Videos/" = "";
        ".git/" = "";
        ".gitattributes" = "";
        ".gitignore" = "";
        ".gitmodules" = "";
        ".DS_Store" = "";
        ".bashprofile" = "";
        ".bashrc" = "";
        ".vimrc" = "";
        ".zprofile" = "";
        ".zshenv" = "";
        ".zshrc" = "";
        # Text
        "*.md" = "";
        "*.rst" = "";
        "*.txt" = "";
        COPYING = "󰿃";
        LICENSE = "󰿃";

        # Archives
        "*.7z" = "";
        "*.bz2" = "";
        "*.gz" = "";
        "*.tar" = "";
        "*.xz" = "";
        "*.zip" = "";

        # Documents
        "*.csv" = "";
        "*.doc" = "";
        "*.doct" = "";
        "*.docx" = "";
        "*.dot" = "";
        "*.ods" = "";
        "*.ots" = "";
        "*.pdf" = "";
        "*.pom" = "";
        "*.pot" = "";
        "*.potx" = "";
        "*.ppm" = "";
        "*.ppmx" = "";
        "*.pps" = "";
        "*.ppsx" = "";
        "*.ppt" = "";
        "*.pptx" = "";
        "*.xlc" = "";
        "*.xlm" = "";
        "*.xls" = "";
        "*.xlsm" = "";
        "*.xlsx" = "";
        "*.xlt" = "";

        # Audio
        "*.aac" = "";
        "*.flac" = "";
        "*.m4a" = "";
        "*.mp2" = "";
        "*.mp3" = "";
        "*.ogg" = "";
        "*.wav" = "";

        # Movies
        "*.avi" = "";
        "*.mkv" = "";
        "*.mov" = "";
        "*.mp4" = "";
        "*.webm" = "";

        # Images
        "*.HEIC" = "";
        "*.avif" = "";
        "*.bmp" = "";
        "*.gif" = "";
        "*.ico" = "";
        "*.jpeg" = "";
        "*.jpg" = "";
        "*.png" = "";
        "*.svg" = "";
        "*.webp" = "";
        "*.xcf" = "";

        # Programming
        "*.c" = "";
        "*.conf" = "";
        "*.cpp" = "";
        "*.css" = "";
        "*.fish" = "";
        "*.go" = "";
        "*.h" = "";
        "*.hpp" = "";
        "*.html" = "";
        "*.ini" = "";
        "*.java" = "";
        "*.js" = "";
        "*.json" = "";
        "*.jsx" = "";
        "*.lock" = "";
        "*.lua" = "";
        "*.nix" = "";
        "*.php" = "";
        "*.py" = "";
        "*.rb" = "";
        "*.rs" = "";
        "*.scss" = "";
        "*.sh" = "";
        "*.swift" = "";
        "*.toml" = "";
        "*.ts" = "";
        "*.tsx" = "";
        "*.vim" = "";
        "*.yaml" = "";
        "*.yml" = "";
        Containerfile = "󰡨";
        Dockerfile = "󰡨";

        # Misc
        "*.bin" = "";
        "*.exe" = "";
        "*.pkg" = "";

        # Default
        "*" = "";
        "*/" = "";
      };
    };
    keymap = {
      manager.keymap = [
        {
          on = ["<C-n>"];
          exec = "''shell 'ripdrag -x -W 400 -H 20 \"$1\"' --confirm''";
        }
        {
          on = ["<Esc>"];
          exec = "escape";
          desc = "Exit visual mode, clear selected, or cancel search";
        }
        {
          on = ["q"];
          exec = "quit";
          desc = "Exit the process";
        }
        {
          on = ["Q"];
          exec = "quit --no-cwd-file";
          desc = "Exit the process without writing cwd-file";
        }
        {
          on = ["<C-q>"];
          exec = "close";
          desc = "Close the current tab, or quit if it is last tab";
        }
        {
          on = ["<C-z>"];
          exec = "suspend";
          desc = "Suspend the process";
        } # Navigation
        {
          on = ["w"];
          exec = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["s"];
          exec = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["W"];
          exec = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = ["S"];
          exec = "arrow 5";
          desc = "Move cursor down 5 lines";
        }
        {
          on = ["<S-Up>"];
          exec = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = ["<S-Down>"];
          exec = "arrow 5";
          desc = "Move cursor down 5 lines";
        }
        {
          on = ["<C-u>"];
          exec = "arrow -50%";
          desc = "Move cursor up half page";
        }
        {
          on = ["<C-d>"];
          exec = "arrow 50%";
          desc = "Move cursor down half page";
        }
        {
          on = ["<C-b>"];
          exec = "arrow -100%";
          desc = "Move cursor up one page";
        }
        {
          on = ["<C-f>"];
          exec = "arrow 100%";
          desc = "Move cursor down one page";
        }
        {
          on = ["<C-PageUp>"];
          exec = "arrow -50%";
          desc = "Move cursor up half page";
        }
        {
          on = ["<C-PageDown>"];
          exec = "arrow 50%";
          desc = "Move cursor down half page";
        }
        {
          on = ["<PageUp>"];
          exec = "arrow -100%";
          desc = "Move cursor up one page";
        }
        {
          on = ["<PageDown>"];
          exec = "arrow 100%";
          desc = "Move cursor down one page";
        }
        {
          on = ["a"];
          exec = ["leave" "escape --visual --select"];
          desc = "Go back to the parent directory";
        }
        {
          on = ["d"];
          exec = ["enter" "escape --visual --select"];
          desc = "Enter the child directory";
        }
        {
          on = ["A"];
          exec = "back";
          desc = "Go back to the previous directory";
        }
        {
          on = ["D"];
          exec = "forward";
          desc = "Go forward to the next directory";
        }
        {
          on = ["<A-k>"];
          exec = "peek -5";
          desc = "Peek up 5 units in the preview";
        }
        {
          on = ["<A-j>"];
          exec = "peek 5";
          desc = "Peek down 5 units in the preview";
        }
        {
          on = ["<A-PageUp>"];
          exec = "peek -5";
          desc = "Peek up 5 units in the preview";
        }
        {
          on = ["<A-PageDown>"];
          exec = "peek 5";
          desc = "Peek down 5 units in the preview";
        }
        {
          on = ["<Up>"];
          exec = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["<Down>"];
          exec = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["<Left>"];
          exec = "leave";
          desc = "Go back to the parent directory";
        }
        {
          on = ["<Right>"];
          exec = "enter";
          desc = "Enter the child directory";
        }
        {
          on = ["g" "g"];
          exec = "arrow -99999999";
          desc = "Move cursor to the top";
        }
        {
          on = ["G"];
          exec = "arrow 99999999";
          desc = "Move cursor to the bottom";
        } # Selection
        {
          on = ["<Space>"];
          exec = ["select --state=none" "arrow 1"];
          desc = "Toggle the current selection state";
        }
        {
          on = ["v"];
          exec = "visual_mode";
          desc = "Enter visual mode (selection mode)";
        }
        {
          on = ["V"];
          exec = "visual_mode --unset";
          desc = "Enter visual mode (unset mode)";
        }
        {
          on = ["<C-a>"];
          exec = "select_all --state=true";
          desc = "Select all files";
        }
        {
          on = ["<C-r>"];
          exec = "select_all --state=none";
          desc = "Inverse selection of all files";
        } # Operation
        {
          on = ["o"];
          exec = "open";
          desc = "Open the selected files";
        }
        {
          on = ["O"];
          exec = "open --interactive";
          desc = "Open the selected files interactively";
        }
        {
          on = ["<Enter>"];
          exec = "open";
          desc = "Open the selected files";
        }
        {
          on = ["e"];
          exec = "open";
          desc = "Open the selected files";
        }
        {
          on = ["<C-Enter>"];
          exec = "open --interactive";
          desc = "Open the selected files interactively";
        }
        {
          on = ["y"];
          exec = ["yank" "escape --visual --select"];
          desc = "Copy the selected files";
        }
        {
          on = ["x"];
          exec = ["yank --cut" "escape --visual --select"];
          desc = "Cut the selected files";
        }
        {
          on = ["P"];
          exec = "paste --force";
          desc = "Paste the files (overwrite if the destination exists)";
        }
        {
          on = ["-"];
          exec = "link";
          desc = "Symlink the absolute path of files";
        }
        {
          on = ["_"];
          exec = "link --relative";
          desc = "Symlink the relative path of files";
        }
        {
          on = ["k"];
          exec = ["remove --force"];
          desc = "Move the files to the trash";
        }
        {
          on = ["K"];
          exec = ["remove --permanently" "escape --visual --select"];
          desc = "Permanently delete the files";
        }
        {
          on = ["p"];
          exec = "create";
          desc = "Create a file or directory (ends with / for directories)";
        }
        {
          on = ["r"];
          exec = "rename";
          desc = "Rename a file or directory";
        }
        {
          on = [";"];
          exec = "shell";
          desc = "Run a shell command";
        }
        {
          on = [":"];
          exec = "shell --block";
          desc = "Run a shell command (block the UI until the command finishes)";
        }
        {
          on = ["."];
          exec = "hidden toggle";
          desc = "Toggle the visibility of hidden files";
        }
        {
          on = ["j"];
          exec = "search fd";
          desc = "Search files by name using fd";
        }
        {
          on = ["J"];
          exec = "search rg";
          desc = "Search files by content using ripgrep";
        }
        {
          on = ["<C-s>"];
          exec = "search none";
          desc = "Cancel the ongoing search";
        }
        {
          on = ["z"];
          exec = "jump zoxide";
          desc = "Jump to a directory using zoxide";
        }
        {
          on = ["Z"];
          exec = "jump fzf";
          desc = "Jump to a directory, or reveal a file using fzf";
        } # Linemode
        {
          on = ["m" "s"];
          exec = "linemode size";
          desc = "Set linemode to size";
        }
        {
          on = ["m" "p"];
          exec = "linemode permissions";
          desc = "Set linemode to permissions";
        }
        {
          on = ["m" "m"];
          exec = "linemode mtime";
          desc = "Set linemode to mtime";
        }
        {
          on = ["m" "n"];
          exec = "linemode none";
          desc = "Set linemode to none";
        } # Copy
        {
          on = ["c" "c"];
          exec = "copy path";
          desc = "Copy the absolute path";
        }
        {
          on = ["c" "d"];
          exec = "copy dirname";
          desc = "Copy the path of the parent directory";
        }
        {
          on = ["c" "f"];
          exec = "copy filename";
          desc = "Copy the name of the file";
        }
        {
          on = ["c" "n"];
          exec = "copy name_without_ext";
          desc = "Copy the name of the file without the extension";
        } # Find
        {
          on = ["/"];
          exec = "find --smart";
        }
        {
          on = ["?"];
          exec = "find --previous --smart";
        }
        {
          on = ["n"];
          exec = "find_arrow";
        }
        {
          on = ["N"];
          exec = "find_arrow --previous";
        } # Sorting
        {
          on = ["," "m"];
          exec = "sort modified --dir_first";
          desc = "Sort by modified time";
        }
        {
          on = ["," "M"];
          exec = "sort modified --reverse --dir_first";
          desc = "Sort by modified time (reverse)";
        }
        {
          on = ["," "c"];
          exec = "sort created --dir_first";
          desc = "Sort by created time";
        }
        {
          on = ["," "C"];
          exec = "sort created --reverse --dir_first";
          desc = "Sort by created time (reverse)";
        }
        {
          on = ["," "e"];
          exec = "sort extension --dir_first";
          desc = "Sort by extension";
        }
        {
          on = ["," "E"];
          exec = "sort extension --reverse --dir_first";
          desc = "Sort by extension (reverse)";
        }
        {
          on = ["," "a"];
          exec = "sort alphabetical --dir_first";
          desc = "Sort alphabetically";
        }
        {
          on = ["," "A"];
          exec = "sort alphabetical --reverse --dir_first";
          desc = "Sort alphabetically (reverse)";
        }
        {
          on = ["," "n"];
          exec = "sort natural --dir_first";
          desc = "Sort naturally";
        }
        {
          on = ["," "N"];
          exec = "sort natural --reverse --dir_first";
          desc = "Sort naturally (reverse)";
        }
        {
          on = ["," "s"];
          exec = "sort size --dir_first";
          desc = "Sort by size";
        }
        {
          on = ["," "S"];
          exec = "sort size --reverse --dir_first";
          desc = "Sort by size (reverse)";
        } # Tabs
        {
          on = ["t"];
          exec = "tab_create --current";
          desc = "Create a new tab using the current path";
        }
        {
          on = ["1"];
          exec = "tab_switch 0";
          desc = "Switch to the first tab";
        }
        {
          on = ["2"];
          exec = "tab_switch 1";
          desc = "Switch to the second tab";
        }
        {
          on = ["3"];
          exec = "tab_switch 2";
          desc = "Switch to the third tab";
        }
        {
          on = ["4"];
          exec = "tab_switch 3";
          desc = "Switch to the fourth tab";
        }
        {
          on = ["5"];
          exec = "tab_switch 4";
          desc = "Switch to the fifth tab";
        }
        {
          on = ["6"];
          exec = "tab_switch 5";
          desc = "Switch to the sixth tab";
        }
        {
          on = ["7"];
          exec = "tab_switch 6";
          desc = "Switch to the seventh tab";
        }
        {
          on = ["8"];
          exec = "tab_switch 7";
          desc = "Switch to the eighth tab";
        }
        {
          on = ["9"];
          exec = "tab_switch 8";
          desc = "Switch to the ninth tab";
        }
        {
          on = ["["];
          exec = "tab_switch -1 --relative";
          desc = "Switch to the previous tab";
        }
        {
          on = ["]"];
          exec = "tab_switch 1 --relative";
          desc = "Switch to the next tab";
        }
        {
          on = ["{"];
          exec = "tab_swap -1";
          desc = "Swap the current tab with the previous tab";
        }
        {
          on = ["}"];
          exec = "tab_swap 1";
          desc = "Swap the current tab with the next tab";
        } # Tasks
        {
          on = ["l"];
          exec = "tasks_show";
          desc = "Show the tasks manager";
        } # Goto
        {
          on = ["g" "h"];
          exec = "cd ~";
          desc = "Go to the home directory";
        }
        {
          on = ["g" "c"];
          exec = "cd ~/.config";
          desc = "Go to the config directory";
        }
        {
          on = ["g" "d"];
          exec = "cd ~/dl";
          desc = "Go to the downloads directory";
        }
        {
          on = ["g" "t"];
          exec = "cd /tmp";
          desc = "Go to the temporary directory";
        }
        {
          on = ["g" "n"];
          exec = "cd ~/nix";
          desc = "Go to the nix directory";
        }
        {
          on = ["g" "<Space>"];
          exec = "cd --interactive";
          desc = "Go to a directory interactively";
        } # Help
        {
          on = ["~"];
          exec = "help";
          desc = "Open help";
        }
      ];
      tasks.keymaps = [
        {
          on = ["<Esc>"];
          exec = "close";
          desc = "Hide the task manager";
        }
        {
          on = ["<C-q>"];
          exec = "close";
          desc = "Hide the task manager";
        }
        {
          on = ["w"];
          exec = "close";
          desc = "Hide the task manager";
        }
        {
          on = ["k"];
          exec = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["j"];
          exec = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["<Up>"];
          exec = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["<Down>"];
          exec = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["<Enter>"];
          exec = "inspect";
          desc = "Inspect the task";
        }
        {
          on = ["x"];
          exec = "cancel";
          desc = "Cancel the task";
        }
        {
          on = ["~"];
          exec = "help";
          desc = "Open help";
        }
      ];
      select.keymap = [
        {
          on = ["<C-q>"];
          exec = "close";
          desc = "Cancel selection";
        }
        {
          on = ["<Esc>"];
          exec = "close";
          desc = "Cancel selection";
        }
        {
          on = ["<Enter>"];
          exec = "close --submit";
          desc = "Submit the selection";
        }
        {
          on = ["k"];
          exec = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["j"];
          exec = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["K"];
          exec = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = ["J"];
          exec = "arrow 5";
          desc = "Move cursor down 5 lines";
        }
        {
          on = ["<Up>"];
          exec = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["<Down>"];
          exec = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["<S-Up>"];
          exec = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = ["<S-Down>"];
          exec = "arrow 5";
          desc = "Move cursor down 5 lines";
        }
        {
          on = ["~"];
          exec = "help";
          desc = "Open help";
        }
      ];
      input.keymap = [
        {
          on = ["<C-q>"];
          exec = "close";
          desc = "Cancel input";
        }
        {
          on = ["<Enter>"];
          exec = "close --submit";
          desc = "Submit the input";
        }
        {
          on = ["<Esc>"];
          exec = "escape";
          desc = "Go back the normal mode, or cancel input";
        } # Mode
        {
          on = ["i"];
          exec = "insert";
          desc = "Enter insert mode";
        }
        {
          on = ["a"];
          exec = "insert --append";
          desc = "Enter append mode";
        }
        {
          on = ["I"];
          exec = ["move -999" "insert"];
          desc = "Move to the BOL, and enter insert mode";
        }
        {
          on = ["A"];
          exec = ["move 999" "insert --append"];
          desc = "Move to the EOL, and enter append mode";
        }
        {
          on = ["v"];
          exec = "visual";
          desc = "Enter visual mode";
        }
        {
          on = ["V"];
          exec = ["move -999" "visual" "move 999"];
          desc = "Enter visual mode and select all";
        } # Character-wise movement
        {
          on = ["h"];
          exec = "move -1";
          desc = "Move back a character";
        }
        {
          on = ["l"];
          exec = "move 1";
          desc = "Move forward a character";
        }
        {
          on = ["<Left>"];
          exec = "move -1";
          desc = "Move back a character";
        }
        {
          on = ["<Right>"];
          exec = "move 1";
          desc = "Move forward a character";
        }
        {
          on = ["<C-b>"];
          exec = "move -1";
          desc = "Move back a character";
        }
        {
          on = ["<C-f>"];
          exec = "move 1";
          desc = "Move forward a character";
        } # Word-wise movement
        {
          on = ["b"];
          exec = "backward";
          desc = "Move back to the start of the current or previous word";
        }
        {
          on = ["w"];
          exec = "forward";
          desc = "Move forward to the start of the next word";
        }
        {
          on = ["e"];
          exec = "forward --end-of-word";
          desc = "Move forward to the end of the current or next word";
        }
        {
          on = ["<A-b>"];
          exec = "backward";
          desc = "Move back to the start of the current or previous word";
        }
        {
          on = ["<A-f>"];
          exec = "forward --end-of-word";
          desc = "Move forward to the end of the current or next word";
        } # Line-wise movement
        {
          on = ["0"];
          exec = "move -999";
          desc = "Move to the BOL";
        }
        {
          on = ["$"];
          exec = "move 999";
          desc = "Move to the EOL";
        }
        {
          on = ["<C-a>"];
          exec = "move -999";
          desc = "Move to the BOL";
        }
        {
          on = ["<C-e>"];
          exec = "move 999";
          desc = "Move to the EOL";
        } # Delete
        {
          on = ["<Backspace>"];
          exec = "backspace";
          desc = "Delete the character before the cursor";
        }
        {
          on = ["<C-h>"];
          exec = "backspace";
          desc = "Delete the character before the cursor";
        }
        {
          on = ["<C-d>"];
          exec = "backspace --under";
          desc = "Delete the character under the cursor";
        } # Kill
        {
          on = ["<C-u>"];
          exec = "kill bol";
          desc = "Kill backwards to the BOL";
        }
        {
          on = ["<C-k>"];
          exec = "kill eol";
          desc = "Kill forwards to the EOL";
        }
        {
          on = ["<C-w>"];
          exec = "kill backward";
          desc = "Kill backwards to the start of the current word";
        }
        {
          on = ["<A-d>"];
          exec = "kill forward";
          desc = "Kill forwards to the end of the current word";
        } # Cut/Yank/Paste
        {
          on = ["d"];
          exec = "delete --cut";
          desc = "Cut the selected characters";
        }
        {
          on = ["D"];
          exec = ["delete --cut" "move 999"];
          desc = "Cut until the EOL";
        }
        {
          on = ["c"];
          exec = "delete --cut --insert";
          desc = "Cut the selected characters, and enter insert mode";
        }
        {
          on = ["C"];
          exec = ["delete --cut --insert" "move 999"];
          desc = "Cut until the EOL, and enter insert mode";
        }
        {
          on = ["x"];
          exec = ["delete --cut" "move 1 --in-operating"];
          desc = "Cut the current character";
        }
        {
          on = ["y"];
          exec = "yank";
          desc = "Copy the selected characters";
        }
        {
          on = ["p"];
          exec = "paste";
          desc = "Paste the copied characters after the cursor";
        }
        {
          on = ["P"];
          exec = "paste --before";
          desc = "Paste the copied characters before the cursor";
        } # Undo/Redo
        {
          on = ["u"];
          exec = "undo";
          desc = "Undo the last operation";
        }
        {
          on = ["<C-r>"];
          exec = "redo";
          desc = "Redo the last operation";
        } # Help
        {
          on = ["~"];
          exec = "help";
          desc = "Open help";
        }
      ];
      completion.keymap = [
        {
          on = ["<C-q>"];
          exec = "close";
          desc = "Cancel completion";
        }
        {
          on = ["<Tab>"];
          exec = "close --submit";
          desc = "Submit the completion";
        }
        {
          on = ["<A-k>"];
          exec = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["<A-j>"];
          exec = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["<Up>"];
          exec = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["<Down>"];
          exec = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["~"];
          exec = "help";
          desc = "Open help";
        }
      ];
      help.keymap = [
        {
          on = ["<Esc>"];
          exec = "escape";
          desc = "Clear the filter, or hide the help";
        }
        {
          on = ["q"];
          exec = "close";
          desc = "Exit the process";
        }
        {
          on = ["<C-q>"];
          exec = "close";
          desc = "Hide the help";
        } # Navigation
        {
          on = ["k"];
          exec = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["j"];
          exec = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["K"];
          exec = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = ["J"];
          exec = "arrow 5";
          desc = "Move cursor down 5 lines";
        }
        {
          on = ["<Up>"];
          exec = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["<Down>"];
          exec = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["<S-Up>"];
          exec = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = ["<S-Down>"];
          exec = "arrow 5";
          desc = "Move cursor down 5 lines";
        } # Filtering
        {
          on = ["/"];
          exec = "filter";
          desc = "Apply a filter for the help items";
        }
      ];
    };
  };
  # xdg.configFile."yazi/keymap.toml".source = ./keymap.toml;
  # xdg.configFile."yazi/theme.toml".source = ./theme.toml;
  # xdg.configFile."yazi/yazi.toml".source = ./yazi.toml;
}
