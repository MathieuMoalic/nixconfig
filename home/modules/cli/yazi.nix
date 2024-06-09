{...}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      manager = {
        layout = [1 4 3];
        linemode = "size";
        show_hidden = false;
        show_symlink = true;
        sort_by = "modified";
        sort_dir-first = false;
        sort_reverse = true;
        sort_sensitive = true;
      };

      preview = {
        cache_dir = "";
        max_height = 900;
        max_width = 600;
        tab_size = 2;
        ueberzug_offset = [0 0 0 0];
        ueberzug_scale = 1;
      };

      opener = {
        edit = [
          {
            run = "\$EDITOR \"$@\"";
            block = true;
            for = "unix";
          }
        ];
        extract = [
          {
            run = "ouch d \"$1\"";
            desc = "Extract here";
            for = "unix";
          }
        ];
        open = [
          {
            run = "xdg-open \"$@\"";
            desc = "Open";
            for = "linux";
          }
        ];
        play = [
          {
            run = "mpv \"$@\"";
            orphan = true;
            for = "unix";
          }
        ];
        reveal = [
          {
            run = "exiftool \"$1\"; echo \"Press enter to exit\"; read";
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
        bizarre_retry = 5;
        image_alloc = 536870912; # 512MB
        image_bound = [0 0];
        macro_workers = 10;
        micro_workers = 5;
        suppress_preload = false;
      };

      plugins = {
        preload = [];
      };

      input = {
        # cd
        cd_offset = [0 2 50 3];
        cd_origin = "top-center";
        cd_title = "Change directory:";

        # create
        create_offset = [0 2 50 3];
        create_origin = "top-center";
        create_title = "Create:";

        # rename
        rename_offset = [0 1 50 3];
        rename_origin = "hovered";
        rename_title = "Rename:";

        # trash
        trash_offset = [0 2 50 3];
        trash_origin = "top-center";
        trash_title = "Move {n} selected file{s} to trash? (y/N)";

        # delete
        delete_offset = [0 2 50 3];
        delete_origin = "top-center";
        delete_title = "Delete {n} selected file{s} permanently? (y/N)";

        # find
        find_offset = [0 2 50 3];
        find_origin = "top-center";
        find_title = ["Find next:" "Find previous:"];

        # search
        search_offset = [0 2 50 3];
        search_origin = "top-center";
        search_title = "Search:";

        # shell
        shell_offset = [0 2 50 3];
        shell_origin = "top-center";
        shell_title = ["Shell:" "Shell (block):"];

        # overwrite
        overwrite_offset = [0 2 50 3];
        overwrite_origin = "top-center";
        overwrite_title = "Overwrite an existing file? (y/N)";

        # quit
        quit_offset = [0 2 50 3];
        quit_origin = "top-center";
        quit_title = "{n} task{s} running, sure to quit? (y/N)";
      };

      select = {
        open_offset = [0 1 50 7];
        open_origin = "hovered";
        open_title = "Open with:";
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
        preview_hovered = {underline = true;};

        find_keyword = {
          fg = "yellow";
          italic = true;
        };
        find_position = {
          fg = "magenta";
          bg = "reset";
          italic = true;
        };

        marker_copied = {
          fg = "lightyellow";
          bg = "lightyellow";
        };
        marker_cut = {
          fg = "lightred";
          bg = "lightred";
        };
        marker_selected = {
          fg = "lightgreen";
          bg = "lightgreen";
        };

        tab_aCtive = {
          fg = "black";
          bg = "lightblue";
        };
        tab_inactive = {
          fg = "white";
          bg = "darkgray";
        };
        tab_width = 1;

        border_style = {fg = "gray";};
        border_symbol = "│";

        folder_offset = [1 0 1 0];
        preview_offset = [1 1 1 1];

        syntect_theme = "";
      };

      status = {
        separator_close = "";
        separator_open = "";
        separator_style = {
          fg = "darkgray";
          bg = "darkgray";
        };

        mode_normal = {
          fg = "black";
          bg = "lightblue";
          bold = true;
        };
        mode_select = {
          fg = "black";
          bg = "lightgreen";
          bold = true;
        };
        mode_unset = {
          fg = "black";
          bg = "lightmagenta";
          bold = true;
        };

        progress_error = {
          fg = "red";
          bg = "black";
        };
        progress_label = {bold = true;};
        progress_normal = {
          fg = "blue";
          bg = "black";
        };

        permissions_r = {fg = "lightyellow";};
        permissions_s = {fg = "darkgray";};
        permissions_t = {fg = "lightgreen";};
        permissions_w = {fg = "lightred";};
        permissions_x = {fg = "lightcyan";};
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
        icon_command = "";
        icon_file = "";
        icon_folder = "";
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
        separator_style = {fg = "darkgray";};
      };

      help = {
        desc = {fg = "gray";};
        run = {fg = "cyan";};
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
        "dl/" = "";
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
          run = "''shell 'ripdrag -x -W 400 -H 20 \"$1\"' --confirm''";
        }
        {
          on = ["<Esc>"];
          run = "escape";
          desc = "Exit visual mode, clear selected, or cancel search";
        }
        {
          on = ["q"];
          run = "quit";
          desc = "Exit the process";
        }
        {
          on = ["Q"];
          run = "quit --no-cwd-file";
          desc = "Exit the process without writing cwd-file";
        }
        {
          on = ["<C-q>"];
          run = "close";
          desc = "Close the current tab, or quit if it is last tab";
        }
        {
          on = ["<C-z>"];
          run = "suspend";
          desc = "Suspend the process";
        } # Navigation
        {
          on = ["w"];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["s"];
          run = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["W"];
          run = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = ["S"];
          run = "arrow 5";
          desc = "Move cursor down 5 lines";
        }
        {
          on = ["<S-Up>"];
          run = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = ["<S-Down>"];
          run = "arrow 5";
          desc = "Move cursor down 5 lines";
        }
        {
          on = ["<C-u>"];
          run = "arrow -50%";
          desc = "Move cursor up half page";
        }
        {
          on = ["<C-d>"];
          run = "arrow 50%";
          desc = "Move cursor down half page";
        }
        {
          on = ["<C-b>"];
          run = "arrow -100%";
          desc = "Move cursor up one page";
        }
        {
          on = ["<C-f>"];
          run = "arrow 100%";
          desc = "Move cursor down one page";
        }
        {
          on = ["<C-PageUp>"];
          run = "arrow -50%";
          desc = "Move cursor up half page";
        }
        {
          on = ["<C-PageDown>"];
          run = "arrow 50%";
          desc = "Move cursor down half page";
        }
        {
          on = ["<PageUp>"];
          run = "arrow -100%";
          desc = "Move cursor up one page";
        }
        {
          on = ["<PageDown>"];
          run = "arrow 100%";
          desc = "Move cursor down one page";
        }
        {
          on = ["a"];
          run = ["leave" "escape --visual --select"];
          desc = "Go back to the parent directory";
        }
        {
          on = ["d"];
          run = ["enter" "escape --visual --select"];
          desc = "Enter the child directory";
        }
        {
          on = ["A"];
          run = "back";
          desc = "Go back to the previous directory";
        }
        {
          on = ["D"];
          run = "forward";
          desc = "Go forward to the next directory";
        }
        {
          on = ["<A-k>"];
          run = "peek -5";
          desc = "Peek up 5 units in the preview";
        }
        {
          on = ["<A-j>"];
          run = "peek 5";
          desc = "Peek down 5 units in the preview";
        }
        {
          on = ["<A-PageUp>"];
          run = "peek -5";
          desc = "Peek up 5 units in the preview";
        }
        {
          on = ["<A-PageDown>"];
          run = "peek 5";
          desc = "Peek down 5 units in the preview";
        }
        {
          on = ["<Up>"];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["<Down>"];
          run = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["<Left>"];
          run = "leave";
          desc = "Go back to the parent directory";
        }
        {
          on = ["<Right>"];
          run = "enter";
          desc = "Enter the child directory";
        }
        {
          on = ["g" "g"];
          run = "arrow -99999999";
          desc = "Move cursor to the top";
        }
        {
          on = ["G"];
          run = "arrow 99999999";
          desc = "Move cursor to the bottom";
        } # Selection
        {
          on = ["<Space>"];
          run = ["select --state=none" "arrow 1"];
          desc = "Toggle the current selection state";
        }
        {
          on = ["v"];
          run = "visual_mode";
          desc = "Enter visual mode (selection mode)";
        }
        {
          on = ["V"];
          run = "visual_mode --unset";
          desc = "Enter visual mode (unset mode)";
        }
        {
          on = ["<C-a>"];
          run = "select_all --state=true";
          desc = "Select all files";
        }
        {
          on = ["<C-r>"];
          run = "select_all --state=none";
          desc = "Inverse selection of all files";
        } # Operation
        {
          on = ["o"];
          run = "open";
          desc = "Open the selected files";
        }
        {
          on = ["O"];
          run = "open --interactive";
          desc = "Open the selected files interactively";
        }
        {
          on = ["<Enter>"];
          run = "open";
          desc = "Open the selected files";
        }
        {
          on = ["e"];
          run = "open";
          desc = "Open the selected files";
        }
        {
          on = ["<C-Enter>"];
          run = "open --interactive";
          desc = "Open the selected files interactively";
        }
        {
          on = ["y"];
          run = ["yank" "escape --visual --select"];
          desc = "Copy the selected files";
        }
        {
          on = ["x"];
          run = ["yank --cut" "escape --visual --select"];
          desc = "Cut the selected files";
        }
        {
          on = ["P"];
          run = "paste --force";
          desc = "Paste the files (overwrite if the destination exists)";
        }
        {
          on = ["-"];
          run = "link";
          desc = "Symlink the absolute path of files";
        }
        {
          on = ["_"];
          run = "link --relative";
          desc = "Symlink the relative path of files";
        }
        {
          on = ["k"];
          run = ["remove --force"];
          desc = "Move the files to the trash";
        }
        {
          on = ["K"];
          run = ["remove --permanently" "escape --visual --select"];
          desc = "Permanently delete the files";
        }
        {
          on = ["p"];
          run = "create";
          desc = "Create a file or directory (ends with / for directories)";
        }
        {
          on = ["r"];
          run = "rename";
          desc = "Rename a file or directory";
        }
        {
          on = [";"];
          run = "shell";
          desc = "Run a shell command";
        }
        {
          on = [":"];
          run = "shell --block";
          desc = "Run a shell command (block the UI until the command finishes)";
        }
        {
          on = ["."];
          run = "hidden toggle";
          desc = "Toggle the visibility of hidden files";
        }
        {
          on = ["j"];
          run = "search fd";
          desc = "Search files by name using fd";
        }
        {
          on = ["J"];
          run = "search rg";
          desc = "Search files by content using ripgrep";
        }
        {
          on = ["<C-s>"];
          run = "search none";
          desc = "Cancel the ongoing search";
        }
        {
          on = ["z"];
          run = "jump zoxide";
          desc = "Jump to a directory using zoxide";
        }
        {
          on = ["Z"];
          run = "jump fzf";
          desc = "Jump to a directory, or reveal a file using fzf";
        } # Linemode
        {
          on = ["m" "s"];
          run = "linemode size";
          desc = "Set linemode to size";
        }
        {
          on = ["m" "p"];
          run = "linemode permissions";
          desc = "Set linemode to permissions";
        }
        {
          on = ["m" "m"];
          run = "linemode mtime";
          desc = "Set linemode to mtime";
        }
        {
          on = ["m" "n"];
          run = "linemode none";
          desc = "Set linemode to none";
        } # Copy
        {
          on = ["c" "c"];
          run = "copy path";
          desc = "Copy the absolute path";
        }
        {
          on = ["c" "d"];
          run = "copy dirname";
          desc = "Copy the path of the parent directory";
        }
        {
          on = ["c" "f"];
          run = "copy filename";
          desc = "Copy the name of the file";
        }
        {
          on = ["c" "n"];
          run = "copy name_without_ext";
          desc = "Copy the name of the file without the extension";
        } # Find
        {
          on = ["/"];
          run = "find --smart";
        }
        {
          on = ["?"];
          run = "find --previous --smart";
        }
        {
          on = ["n"];
          run = "find_arrow";
        }
        {
          on = ["N"];
          run = "find_arrow --previous";
        } # Sorting
        {
          on = ["," "m"];
          run = "sort modified --dir_first";
          desc = "Sort by modified time";
        }
        {
          on = ["," "M"];
          run = "sort modified --reverse --dir_first";
          desc = "Sort by modified time (reverse)";
        }
        {
          on = ["," "c"];
          run = "sort created --dir_first";
          desc = "Sort by created time";
        }
        {
          on = ["," "C"];
          run = "sort created --reverse --dir_first";
          desc = "Sort by created time (reverse)";
        }
        {
          on = ["," "e"];
          run = "sort extension --dir_first";
          desc = "Sort by extension";
        }
        {
          on = ["," "E"];
          run = "sort extension --reverse --dir_first";
          desc = "Sort by extension (reverse)";
        }
        {
          on = ["," "a"];
          run = "sort alphabetical --dir_first";
          desc = "Sort alphabetically";
        }
        {
          on = ["," "A"];
          run = "sort alphabetical --reverse --dir_first";
          desc = "Sort alphabetically (reverse)";
        }
        {
          on = ["," "n"];
          run = "sort natural --dir_first";
          desc = "Sort naturally";
        }
        {
          on = ["," "N"];
          run = "sort natural --reverse --dir_first";
          desc = "Sort naturally (reverse)";
        }
        {
          on = ["," "s"];
          run = "sort size --dir_first";
          desc = "Sort by size";
        }
        {
          on = ["," "S"];
          run = "sort size --reverse --dir_first";
          desc = "Sort by size (reverse)";
        } # Tabs
        {
          on = ["t"];
          run = "tab_create --current";
          desc = "Create a new tab using the current path";
        }
        {
          on = ["1"];
          run = "tab_switch 0";
          desc = "Switch to the first tab";
        }
        {
          on = ["2"];
          run = "tab_switch 1";
          desc = "Switch to the second tab";
        }
        {
          on = ["3"];
          run = "tab_switch 2";
          desc = "Switch to the third tab";
        }
        {
          on = ["4"];
          run = "tab_switch 3";
          desc = "Switch to the fourth tab";
        }
        {
          on = ["5"];
          run = "tab_switch 4";
          desc = "Switch to the fifth tab";
        }
        {
          on = ["6"];
          run = "tab_switch 5";
          desc = "Switch to the sixth tab";
        }
        {
          on = ["7"];
          run = "tab_switch 6";
          desc = "Switch to the seventh tab";
        }
        {
          on = ["8"];
          run = "tab_switch 7";
          desc = "Switch to the eighth tab";
        }
        {
          on = ["9"];
          run = "tab_switch 8";
          desc = "Switch to the ninth tab";
        }
        {
          on = ["["];
          run = "tab_switch -1 --relative";
          desc = "Switch to the previous tab";
        }
        {
          on = ["]"];
          run = "tab_switch 1 --relative";
          desc = "Switch to the next tab";
        }
        {
          on = ["{"];
          run = "tab_swap -1";
          desc = "Swap the current tab with the previous tab";
        }
        {
          on = ["}"];
          run = "tab_swap 1";
          desc = "Swap the current tab with the next tab";
        } # Tasks
        {
          on = ["l"];
          run = "tasks_show";
          desc = "Show the tasks manager";
        } # Goto
        {
          on = ["g" "h"];
          run = "cd ~";
          desc = "Go to the home directory";
        }
        {
          on = ["g" "c"];
          run = "cd ~/.config";
          desc = "Go to the config directory";
        }
        {
          on = ["g" "d"];
          run = "cd ~/dl";
          desc = "Go to the downloads directory";
        }
        {
          on = ["g" "t"];
          run = "cd /tmp";
          desc = "Go to the temporary directory";
        }
        {
          on = ["g" "n"];
          run = "cd ~/nix";
          desc = "Go to the nix directory";
        }
        {
          on = ["g" "<Space>"];
          run = "cd --interactive";
          desc = "Go to a directory interactively";
        } # Help
        {
          on = ["~"];
          run = "help";
          desc = "Open help";
        }
      ];
      tasks.keymaps = [
        {
          on = ["<Esc>"];
          run = "close";
          desc = "Hide the task manager";
        }
        {
          on = ["<C-q>"];
          run = "close";
          desc = "Hide the task manager";
        }
        {
          on = ["w"];
          run = "close";
          desc = "Hide the task manager";
        }
        {
          on = ["k"];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["j"];
          run = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["<Up>"];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["<Down>"];
          run = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["<Enter>"];
          run = "inspect";
          desc = "Inspect the task";
        }
        {
          on = ["x"];
          run = "cancel";
          desc = "Cancel the task";
        }
        {
          on = ["~"];
          run = "help";
          desc = "Open help";
        }
      ];
      select.keymap = [
        {
          on = ["<C-q>"];
          run = "close";
          desc = "Cancel selection";
        }
        {
          on = ["<Esc>"];
          run = "close";
          desc = "Cancel selection";
        }
        {
          on = ["<Enter>"];
          run = "close --submit";
          desc = "Submit the selection";
        }
        {
          on = ["k"];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["j"];
          run = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["K"];
          run = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = ["J"];
          run = "arrow 5";
          desc = "Move cursor down 5 lines";
        }
        {
          on = ["<Up>"];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["<Down>"];
          run = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["<S-Up>"];
          run = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = ["<S-Down>"];
          run = "arrow 5";
          desc = "Move cursor down 5 lines";
        }
        {
          on = ["~"];
          run = "help";
          desc = "Open help";
        }
      ];
      input.keymap = [
        {
          on = ["<C-q>"];
          run = "close";
          desc = "Cancel input";
        }
        {
          on = ["<Enter>"];
          run = "close --submit";
          desc = "Submit the input";
        }
        {
          on = ["<Esc>"];
          run = "escape";
          desc = "Go back the normal mode, or cancel input";
        } # Mode
        {
          on = ["i"];
          run = "insert";
          desc = "Enter insert mode";
        }
        {
          on = ["a"];
          run = "insert --append";
          desc = "Enter append mode";
        }
        {
          on = ["I"];
          run = ["move -999" "insert"];
          desc = "Move to the BOL, and enter insert mode";
        }
        {
          on = ["A"];
          run = ["move 999" "insert --append"];
          desc = "Move to the EOL, and enter append mode";
        }
        {
          on = ["v"];
          run = "visual";
          desc = "Enter visual mode";
        }
        {
          on = ["V"];
          run = ["move -999" "visual" "move 999"];
          desc = "Enter visual mode and select all";
        } # Character-wise movement
        {
          on = ["h"];
          run = "move -1";
          desc = "Move back a character";
        }
        {
          on = ["l"];
          run = "move 1";
          desc = "Move forward a character";
        }
        {
          on = ["<Left>"];
          run = "move -1";
          desc = "Move back a character";
        }
        {
          on = ["<Right>"];
          run = "move 1";
          desc = "Move forward a character";
        }
        {
          on = ["<C-b>"];
          run = "move -1";
          desc = "Move back a character";
        }
        {
          on = ["<C-f>"];
          run = "move 1";
          desc = "Move forward a character";
        } # Word-wise movement
        {
          on = ["b"];
          run = "backward";
          desc = "Move back to the start of the current or previous word";
        }
        {
          on = ["w"];
          run = "forward";
          desc = "Move forward to the start of the next word";
        }
        {
          on = ["e"];
          run = "forward --end-of-word";
          desc = "Move forward to the end of the current or next word";
        }
        {
          on = ["<A-b>"];
          run = "backward";
          desc = "Move back to the start of the current or previous word";
        }
        {
          on = ["<A-f>"];
          run = "forward --end-of-word";
          desc = "Move forward to the end of the current or next word";
        } # Line-wise movement
        {
          on = ["0"];
          run = "move -999";
          desc = "Move to the BOL";
        }
        {
          on = ["$"];
          run = "move 999";
          desc = "Move to the EOL";
        }
        {
          on = ["<C-a>"];
          run = "move -999";
          desc = "Move to the BOL";
        }
        {
          on = ["<C-e>"];
          run = "move 999";
          desc = "Move to the EOL";
        } # Delete
        {
          on = ["<Backspace>"];
          run = "backspace";
          desc = "Delete the character before the cursor";
        }
        {
          on = ["<C-h>"];
          run = "backspace";
          desc = "Delete the character before the cursor";
        }
        {
          on = ["<C-d>"];
          run = "backspace --under";
          desc = "Delete the character under the cursor";
        } # Kill
        {
          on = ["<C-u>"];
          run = "kill bol";
          desc = "Kill backwards to the BOL";
        }
        {
          on = ["<C-k>"];
          run = "kill eol";
          desc = "Kill forwards to the EOL";
        }
        {
          on = ["<C-w>"];
          run = "kill backward";
          desc = "Kill backwards to the start of the current word";
        }
        {
          on = ["<A-d>"];
          run = "kill forward";
          desc = "Kill forwards to the end of the current word";
        } # Cut/Yank/Paste
        {
          on = ["d"];
          run = "delete --cut";
          desc = "Cut the selected characters";
        }
        {
          on = ["D"];
          run = ["delete --cut" "move 999"];
          desc = "Cut until the EOL";
        }
        {
          on = ["c"];
          run = "delete --cut --insert";
          desc = "Cut the selected characters, and enter insert mode";
        }
        {
          on = ["C"];
          run = ["delete --cut --insert" "move 999"];
          desc = "Cut until the EOL, and enter insert mode";
        }
        {
          on = ["x"];
          run = ["delete --cut" "move 1 --in-operating"];
          desc = "Cut the current character";
        }
        {
          on = ["y"];
          run = "yank";
          desc = "Copy the selected characters";
        }
        {
          on = ["p"];
          run = "paste";
          desc = "Paste the copied characters after the cursor";
        }
        {
          on = ["P"];
          run = "paste --before";
          desc = "Paste the copied characters before the cursor";
        } # Undo/Redo
        {
          on = ["u"];
          run = "undo";
          desc = "Undo the last operation";
        }
        {
          on = ["<C-r>"];
          run = "redo";
          desc = "Redo the last operation";
        } # Help
        {
          on = ["~"];
          run = "help";
          desc = "Open help";
        }
      ];
      completion.keymap = [
        {
          on = ["<C-q>"];
          run = "close";
          desc = "Cancel completion";
        }
        {
          on = ["<Tab>"];
          run = "close --submit";
          desc = "Submit the completion";
        }
        {
          on = ["<A-k>"];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["<A-j>"];
          run = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["<Up>"];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["<Down>"];
          run = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["~"];
          run = "help";
          desc = "Open help";
        }
      ];
      help.keymap = [
        {
          on = ["<Esc>"];
          run = "escape";
          desc = "Clear the filter, or hide the help";
        }
        {
          on = ["q"];
          run = "close";
          desc = "Exit the process";
        }
        {
          on = ["<C-q>"];
          run = "close";
          desc = "Hide the help";
        } # Navigation
        {
          on = ["k"];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["j"];
          run = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["K"];
          run = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = ["J"];
          run = "arrow 5";
          desc = "Move cursor down 5 lines";
        }
        {
          on = ["<Up>"];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["<Down>"];
          run = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["<S-Up>"];
          run = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = ["<S-Down>"];
          run = "arrow 5";
          desc = "Move cursor down 5 lines";
        } # Filtering
        {
          on = ["/"];
          run = "filter";
          desc = "Apply a filter for the help items";
        }
      ];
    };
  };
}
