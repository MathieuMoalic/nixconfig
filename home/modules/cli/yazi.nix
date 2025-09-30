{pkgs, ...}: {
  xdg.configFile."yazi/init.lua".text = ''
    require("starship"):setup()

    Status:children_add(function()
      local h = cx.active.current.hovered
      if h == nil or ya.target_family() ~= "unix" then
        return ""
      end

      return ui.Line {
        ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
        ":",
        ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
        " ",
      }
    end, 500, Status.RIGHT)

    Status:children_add(function(self)
      local h = self._current.hovered
      if h and h.link_to then
        return " -> " .. tostring(h.link_to)
      else
        return ""
      end
    end, 3300, Status.LEFT)
  '';
  programs.yazi = {
    enable = true;
    plugins = with pkgs.yaziPlugins; {
      inherit toggle-pane chmod ouch smart-enter starship mime-ext mount rich-preview restore;
    };
    settings = {
      mgr = {
        ratio = [0 1 2];
        linemode = "size";
        show_hidden = false;
        show_symlink = true;
        sort_by = "mtime";
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
            run = "ouch d -y \"$@\"";
            desc = "Extract here";
            for = "unix";
          }
        ];
        open = [
          {
            run = "xdg-open \"$@\"  &";
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
        prepend_previewers = [
          {
            name = "*.csv";
            run = "rich-preview";
          }
          {
            name = "*.md";
            run = "rich-preview";
          }
          {
            name = "*.rst";
            run = "rich-preview";
          }
          {
            name = "*.ipynb";
            run = "rich-preview";
          }
          {
            name = "*.json";
            run = "rich-preview";
          }
          {
            mime = "application/*zip";
            run = "ouch";
          }
          {
            mime = "application/x-tar";
            run = "ouch";
          }
          {
            mime = "application/x-bzip2";
            run = "ouch";
          }
          {
            mime = "application/x-7z-compressed";
            run = "ouch";
          }
          {
            mime = "application/x-rar";
            run = "ouch";
          }
          {
            mime = "application/x-xz";
            run = "ouch";
          }
        ];
        append_previewers = [
        ];
      };
      plugin = {
        prepend_fetchers = [
          {
            id = "mime";
            name = "*";
            run = "mime-ext";
            prio = "high";
          }
        ];
      };

      input = {
        # cd
        cd_offset = [0 2 50 3];
        cd_origin = "top-center";
        cd_title = "Change directory:";

        # create
        create_offset = [0 2 50 3];
        create_origin = "top-center";
        create_title = ["Create:" "Create directory:"];

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
      mgr = {
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
      help.keymap = [
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
          desc = "Move cursor up 5";
        }
        {
          on = ["J"];
          run = "arrow 5";
          desc = "Move cursor down 5";
        }
        {
          on = ["q"];
          run = "close --submit";
          desc = "Close help";
        }
        {
          on = ["f"];
          run = "filter";
          desc = "Filter help";
        }
      ];

      input.keymap = [
        {
          desc = "Submit the input";
          on = ["<Enter>"];
          run = "close --submit";
        }
        {
          desc = "Cancel input";
          on = ["<Esc>"];
          run = "close";
        }
        {
          desc = "Move forward a character";
          on = ["<Right>"];
          run = "move 1";
        }
        {
          desc = "Move back a character";
          on = ["<Left>"];
          run = "move -1";
        }
        {
          desc = "Delete the character before the cursor";
          on = ["<Backspace>"];
          run = "backspace";
        }
        {
          desc = "Delete the character under the cursor";
          on = ["<Delete>"];
          run = "backspace --under";
        }
        {
          desc = "Undo the last operation";
          on = ["<C-z>"];
          run = "undo";
        }
        {
          desc = "Redo the last operation";
          on = ["<C-y>"];
          run = "redo";
        }
      ];

      mgr.keymap = [
        {
          on = ["u"];
          run = "plugin restore";
        }
        {
          on = ["T"];
          run = "search rg";
          desc = "Search files by content using ripgrep";
        }
        {
          on = ["t"];
          run = "search fd";
          desc = "Search files by name using fd";
        }
        {
          on = ["C"];
          run = "plugin ouch --args=zip";
          desc = "Compress with ouch";
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
          desc = "Move cursor up 5";
        }
        {
          on = ["J"];
          run = "arrow 5";
          desc = "Move cursor down 5";
        }
        {
          on = ["h"];
          run = ["leave" "escape --visual --select"];
          desc = "Parent directory";
        }
        {
          on = ["l"];
          run = ["plugin --sync smart-enter"];
          desc = "Child directory";
        }
        {
          on = ["q"];
          run = "close";
          desc = "close";
        }
        {
          on = ["<C-Space>"];
          run = "close";
          desc = "close";
        }
        {
          on = ["Q"];
          run = "quit --no-cwd-file";
          desc = "close, without writing cwd file";
        }
        {
          on = ["M"];
          run = "plugin mount";
        }
        {
          on = ["y"];
          run = ["yank" ''shell --confirm "for path in "$@"; do echo "file://$path"; done | wl-copy -t text/uri-list" ''];
        }
        {
          on = ["Y"];
          run = ["unyank"];
        }
        {
          on = ["R"];
          run = ''shell 'ripdrag -x "$@"' --confirm'';
        }
        {
          on = ["i"];
          run = ''shell 'lnmv $1' --confirm'';
        }
        {
          on = ["f"];
          run = "plugin smart-filter";
        }
        {
          on = ["m"];
          run = "plugin toggle-pane max-preview";
        }
        {
          on = ["w"];
          run = "plugin toggle-pane min-preview";
        }
        {
          on = ["c"];
          run = "plugin chmod";
        }
        {
          on = ["?"];
          run = "help";
        }
        {
          on = ["r"];
          run = "rename";
        }
        {
          desc = "Close the current tab, or quit if it is last tab";
          on = ["<C-w>"];
          run = "close";
        }
        {
          desc = "Toggle the current selection state";
          on = ["<Space>"];
          run = ["toggle" "arrow 1"];
        }
        {
          desc = "Select all files";
          on = ["<C-a>"];
          run = "toggle_all --state=on";
        }
        {
          desc = "Inverse selection of all files";
          on = ["<C-r>"];
          run = "toggle_all --state=off";
        }
        {
          desc = "Open the selected files";
          on = ["<Enter>"];
          run = "open";
        }
        {
          desc = "Open the selected files";
          on = ["e"];
          run = "open";
        }
        {
          desc = "Open the selected files interactively";
          on = ["o"];
          run = "open --interactive";
        }
        {
          desc = "Copy the selected files";
          on = ["y"];
          run = ["yank" "escape --visual --select"];
        }
        {
          desc = "Cut the selected files";
          on = ["x"];
          run = ["yank --cut" "escape --visual --select"];
        }
        {
          desc = "Paste the files (overwrite if the destination exists)";
          on = ["p"];
          run = ["paste --force" "unyank"];
        }
        {
          desc = "Symlink the absolute path of files";
          on = ["-"];
          run = "link";
        }
        {
          desc = "Symlink the relative path of files";
          on = ["_"];
          run = "link --relative";
        }
        {
          desc = "Move the files to the trash";
          on = ["d"];
          run = ["remove" "escape --visual --select"];
        }
        {
          desc = "Permanently delete the files";
          on = ["D"];
          run = ["remove --permanently" "escape --visual --select"];
        }
        {
          desc = "Create a file or directory (ends with / for directories)";
          on = ["n"];
          run = "create";
        }
        {
          desc = "Toggle the visibility of hidden files";
          on = ["."];
          run = "hidden toggle";
        }
        {
          desc = "size";
          on = ["s" "s"];
          run = "linemode size";
        }
        {
          desc = "permissions";
          on = ["s" "p"];
          run = "linemode permissions";
        }
        {
          desc = "mtime";
          on = ["s" "m"];
          run = "linemode mtime";
        }
        {
          desc = "none";
          on = ["s" "n"];
          run = "linemode none";
        }
        {
          desc = "Copy the absolute path";
          on = ["<C-c>"];
          run = "copy path";
        }
        {
          desc = "Sort by mtime time";
          on = ["," "m"];
          run = "sort mtime --dir_first";
        }
        {
          desc = "Sort by mtime time (reverse)";
          on = ["," "M"];
          run = "sort mtime --reverse --dir_first";
        }
        {
          desc = "Sort by created time";
          on = ["," "c"];
          run = "sort created --dir_first";
        }
        {
          desc = "Sort by created time (reverse)";
          on = ["," "C"];
          run = "sort created --reverse --dir_first";
        }
        {
          desc = "Sort by extension";
          on = ["," "e"];
          run = "sort extension --dir_first";
        }
        {
          desc = "Sort by extension (reverse)";
          on = ["," "E"];
          run = "sort extension --reverse --dir_first";
        }
        {
          desc = "Sort alphabetically";
          on = ["," "a"];
          run = "sort alphabetical --dir_first";
        }
        {
          desc = "Sort alphabetically (reverse)";
          on = ["," "A"];
          run = "sort alphabetical --reverse --dir_first";
        }
        {
          desc = "Sort naturally";
          on = ["," "n"];
          run = "sort natural --dir_first";
        }
        {
          desc = "Sort naturally (reverse)";
          on = ["," "N"];
          run = "sort natural --reverse --dir_first";
        }
        {
          desc = "Sort by size";
          on = ["," "s"];
          run = "sort size --dir_first";
        }
        {
          desc = "Sort by size (reverse)";
          on = ["," "S"];
          run = "sort size --reverse --dir_first";
        }
        {
          desc = "Show the tasks manager";
          on = ["L"];
          run = "tasks_show";
        }
        {
          desc = "home";
          on = ["g" "h"];
          run = "cd ~";
        }
        {
          desc = "config";
          on = ["g" "c"];
          run = "cd ~/.config";
        }
        {
          desc = "downloads";
          on = ["g" "d"];
          run = "cd ~/dl";
        }
        {
          desc = "temporary";
          on = ["g" "t"];
          run = "cd /tmp";
        }
        {
          desc = "nix";
          on = ["g" "n"];
          run = "cd ~/nix";
        }
      ];

      select.keymap = [
        {
          desc = "Cancel selection";
          on = ["q"];
          run = "close";
        }
        {
          desc = "Cancel selection";
          on = ["o"];
          run = "close";
        }
        {
          desc = "Submit the selection";
          on = ["<Enter>"];
          run = "close --submit";
        }
        {
          desc = "Submit the selection";
          on = ["l"];
          run = "close --submit";
        }
        {
          desc = "Move cursor up";
          on = ["k"];
          run = "arrow -1";
        }
        {
          desc = "Move cursor down";
          on = ["j"];
          run = "arrow 1";
        }
        {
          desc = "Move cursor up 5 lines";
          on = ["K"];
          run = "arrow -5";
        }
        {
          desc = "Move cursor down 5 lines";
          on = ["J"];
          run = "arrow 5";
        }
        {
          desc = "Open help";
          on = ["?"];
          run = "help";
        }
      ];

      tasks.keymap = [
        {
          desc = "Hide the task manager";
          on = ["q"];
          run = "close";
        }
        {
          desc = "Move cursor up";
          on = ["k"];
          run = "arrow -1";
        }
        {
          desc = "Move cursor down";
          on = ["j"];
          run = "arrow 1";
        }
        {
          desc = "Inspect the task";
          on = ["<Enter>"];
          run = "inspect";
        }
        {
          desc = "Cancel the task";
          on = ["d"];
          run = "cancel";
        }
        {
          desc = "Open help";
          on = ["?"];
          run = "help";
        }
      ];
    };
  };
}
