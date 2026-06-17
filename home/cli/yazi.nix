{
  flake.homeModules.yazi = {pkgs, ...}: {
    programs.yazi = {
      enable = true;
      shellWrapperName = "yy";

      plugins = with pkgs.yaziPlugins; {
        inherit
          toggle-pane
          chmod
          ouch
          smart-enter
          starship
          mount
          rich-preview
          restore
          ;
      };

      extraPackages = with pkgs; [
        file
        p7zip
        fd
        ripgrep
        ouch
        xdg-utils
        mpv
        wl-clipboard
        ripdrag
        perlPackages.ImageExifTool
      ];

      initLua = ''
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

      settings = {
        mgr = {
          ratio = [0 1 2];
          linemode = "size";
          show_hidden = false;
          show_symlink = true;
          sort_by = "mtime";
          sort_dir_first = false;
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
              run = "$EDITOR %s";
              block = true;
              for = "unix";
            }
          ];

          extract = [
            {
              run = "ouch d -y %s";
              desc = "Extract here";
              block = true;
              for = "unix";
            }
          ];

          open = [
            {
              run = "xdg-open %s1";
              desc = "Open";
              orphan = true;
              for = "unix";
            }
          ];

          play = [
            {
              run = "mpv %s";
              orphan = true;
              for = "unix";
            }
          ];

          reveal = [
            {
              run = "exiftool %s1; echo 'Press enter to exit'; read";
              block = true;
              desc = "Show EXIF";
              for = "unix";
            }
          ];
        };

        open = {
          rules = let
            extractMimes = [
              "application/zip"
              "application/gzip"
              "application/x-gzip"
              "application/x-tar"
              "application/x-bzip"
              "application/x-bzip2"
              "application/x-7z-compressed"
              "application/x-rar"
              "application/x-xz"
            ];

            extractRule = mime: {
              inherit mime;
              use = ["extract" "reveal"];
            };
          in
            (map extractRule extractMimes)
            ++ [
              {
                mime = "text/*";
                use = ["edit" "reveal"];
              }
              {
                mime = "*";
                use = ["open" "reveal"];
              }
            ];
        };

        tasks = {
          bizarre_retry = 5;
          file_workers = 10;
          plugin_workers = 10;
          fetch_workers = 5;
          preload_workers = 5;
          process_workers = 5;
          image_alloc = 536870912; # 512MB
          image_bound = [0 0];
          suppress_preload = false;
        };

        plugin = {
          prepend_previewers = [
            {
              url = "*.csv";
              run = "rich-preview";
            }
            {
              url = "*.md";
              run = "rich-preview";
            }
            {
              url = "*.rst";
              run = "rich-preview";
            }
            {
              url = "*.ipynb";
              run = "rich-preview";
            }
            {
              url = "*.json";
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

          append_previewers = [];
        };

        input = {
          cd_offset = [0 2 50 3];
          cd_origin = "top-center";
          cd_title = "Change directory:";

          create_offset = [0 2 50 3];
          create_origin = "top-center";
          create_title = ["Create:" "Create directory:"];

          rename_offset = [0 1 50 3];
          rename_origin = "hovered";
          rename_title = "Rename:";

          find_offset = [0 2 50 3];
          find_origin = "top-center";
          find_title = ["Find next:" "Find previous:"];

          search_offset = [0 2 50 3];
          search_origin = "top-center";
          search_title = "Search:";

          shell_offset = [0 2 50 3];
          shell_origin = "top-center";
          shell_title = ["Shell:" "Shell (block):"];
        };

        confirm = {
          trash_offset = [0 2 50 3];
          trash_origin = "top-center";
          trash_title = "Move {n} selected file{s} to trash? (y/N)";

          delete_offset = [0 2 50 3];
          delete_origin = "top-center";
          delete_title = "Delete {n} selected file{s} permanently? (y/N)";

          overwrite_offset = [0 2 50 3];
          overwrite_origin = "top-center";
          overwrite_title = "Overwrite an existing file? (y/N)";

          quit_offset = [0 2 50 3];
          quit_origin = "top-center";
          quit_title = "{n} task{s} running, sure to quit? (y/N)";
        };

        pick = {
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

          find_keyword = {
            fg = "yellow";
            italic = true;
          };

          find_position = {
            fg = "magenta";
            bg = "reset";
            italic = true;
          };

          symlink_target = {
            fg = "magenta";
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

          marker_marked = {
            fg = "lightcyan";
            bg = "lightcyan";
          };

          border_style = {fg = "gray";};
          border_symbol = "│";

          syntect_theme = "";
        };

        tabs = {
          active = {
            fg = "black";
            bg = "lightblue";
          };

          inactive = {
            fg = "white";
            bg = "darkgray";
          };

          sep_inner = {
            open = "";
            close = "";
          };

          sep_outer = {
            open = "";
            close = "";
          };
        };

        mode = {
          normal_main = {
            fg = "black";
            bg = "lightblue";
            bold = true;
          };

          normal_alt = {
            fg = "lightblue";
            bg = "darkgray";
          };

          select_main = {
            fg = "black";
            bg = "lightgreen";
            bold = true;
          };

          select_alt = {
            fg = "lightgreen";
            bg = "darkgray";
          };

          unset_main = {
            fg = "black";
            bg = "lightmagenta";
            bold = true;
          };

          unset_alt = {
            fg = "lightmagenta";
            bg = "darkgray";
          };
        };

        status = {
          sep_left = {
            open = "";
            close = "";
          };

          sep_right = {
            open = "";
            close = "";
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

          perm_read = {fg = "lightyellow";};
          perm_write = {fg = "lightred";};
          perm_exec = {fg = "lightcyan";};
          perm_sep = {fg = "darkgray";};
          perm_type = {fg = "lightgreen";};
        };

        pick = {
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

        cmp = {
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
          icon_info = "";
          icon_warn = "";
          icon_error = "";
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
              mime = "application/x-xz";
              fg = "magenta";
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
              url = "*/";
              fg = "blue";
            }
          ];
        };

        icon = {
          prepend_dirs = [
            {
              name = ".config";
              text = "";
            }
            {
              name = "Desktop";
              text = "";
            }
            {
              name = "Development";
              text = "";
            }
            {
              name = "Documents";
              text = "";
            }
            {
              name = "dl";
              text = "";
            }
            {
              name = "Library";
              text = "";
            }
            {
              name = "Movies";
              text = "";
            }
            {
              name = "Music";
              text = "";
            }
            {
              name = "Pictures";
              text = "";
            }
            {
              name = "Public";
              text = "";
            }
            {
              name = "Videos";
              text = "";
            }
            {
              name = ".git";
              text = "";
            }
          ];

          prepend_files = [
            {
              name = ".gitattributes";
              text = "";
            }
            {
              name = ".gitignore";
              text = "";
            }
            {
              name = ".gitmodules";
              text = "";
            }
            {
              name = ".DS_Store";
              text = "";
            }
            {
              name = ".bashprofile";
              text = "";
            }
            {
              name = ".bashrc";
              text = "";
            }
            {
              name = ".vimrc";
              text = "";
            }
            {
              name = ".zprofile";
              text = "";
            }
            {
              name = ".zshenv";
              text = "";
            }
            {
              name = ".zshrc";
              text = "";
            }
            {
              name = "COPYING";
              text = "󰿃";
            }
            {
              name = "LICENSE";
              text = "󰿃";
            }
            {
              name = "Containerfile";
              text = "󰡨";
            }
            {
              name = "Dockerfile";
              text = "󰡨";
            }
          ];

          prepend_exts = [
            {
              name = "md";
              text = "";
            }
            {
              name = "rst";
              text = "";
            }
            {
              name = "txt";
              text = "";
            }

            {
              name = "7z";
              text = "";
            }
            {
              name = "bz2";
              text = "";
            }
            {
              name = "gz";
              text = "";
            }
            {
              name = "tar";
              text = "";
            }
            {
              name = "xz";
              text = "";
            }
            {
              name = "zip";
              text = "";
            }

            {
              name = "csv";
              text = "";
            }
            {
              name = "doc";
              text = "";
            }
            {
              name = "doct";
              text = "";
            }
            {
              name = "docx";
              text = "";
            }
            {
              name = "dot";
              text = "";
            }
            {
              name = "ods";
              text = "";
            }
            {
              name = "ots";
              text = "";
            }
            {
              name = "pdf";
              text = "";
            }
            {
              name = "ppt";
              text = "";
            }
            {
              name = "pptx";
              text = "";
            }
            {
              name = "xls";
              text = "";
            }
            {
              name = "xlsx";
              text = "";
            }

            {
              name = "aac";
              text = "";
            }
            {
              name = "flac";
              text = "";
            }
            {
              name = "m4a";
              text = "";
            }
            {
              name = "mp2";
              text = "";
            }
            {
              name = "mp3";
              text = "";
            }
            {
              name = "ogg";
              text = "";
            }
            {
              name = "wav";
              text = "";
            }

            {
              name = "avi";
              text = "";
            }
            {
              name = "mkv";
              text = "";
            }
            {
              name = "mov";
              text = "";
            }
            {
              name = "mp4";
              text = "";
            }
            {
              name = "webm";
              text = "";
            }

            {
              name = "HEIC";
              text = "";
            }
            {
              name = "avif";
              text = "";
            }
            {
              name = "bmp";
              text = "";
            }
            {
              name = "gif";
              text = "";
            }
            {
              name = "ico";
              text = "";
            }
            {
              name = "jpeg";
              text = "";
            }
            {
              name = "jpg";
              text = "";
            }
            {
              name = "png";
              text = "";
            }
            {
              name = "svg";
              text = "";
            }
            {
              name = "webp";
              text = "";
            }
            {
              name = "xcf";
              text = "";
            }

            {
              name = "c";
              text = "";
            }
            {
              name = "conf";
              text = "";
            }
            {
              name = "cpp";
              text = "";
            }
            {
              name = "css";
              text = "";
            }
            {
              name = "fish";
              text = "";
            }
            {
              name = "go";
              text = "";
            }
            {
              name = "h";
              text = "";
            }
            {
              name = "hpp";
              text = "";
            }
            {
              name = "html";
              text = "";
            }
            {
              name = "ini";
              text = "";
            }
            {
              name = "java";
              text = "";
            }
            {
              name = "js";
              text = "";
            }
            {
              name = "json";
              text = "";
            }
            {
              name = "jsx";
              text = "";
            }
            {
              name = "lock";
              text = "";
            }
            {
              name = "lua";
              text = "";
            }
            {
              name = "nix";
              text = "";
            }
            {
              name = "php";
              text = "";
            }
            {
              name = "py";
              text = "";
            }
            {
              name = "rb";
              text = "";
            }
            {
              name = "rs";
              text = "";
            }
            {
              name = "scss";
              text = "";
            }
            {
              name = "sh";
              text = "";
            }
            {
              name = "swift";
              text = "";
            }
            {
              name = "toml";
              text = "";
            }
            {
              name = "ts";
              text = "";
            }
            {
              name = "tsx";
              text = "";
            }
            {
              name = "vim";
              text = "";
            }
            {
              name = "yaml";
              text = "";
            }
            {
              name = "yml";
              text = "";
            }

            {
              name = "bin";
              text = "";
            }
            {
              name = "exe";
              text = "";
            }
            {
              name = "pkg";
              text = "";
            }
          ];
        };
      };

      keymap = {
        mgr.prepend_keymap = [
          {
            on = ["u"];
            run = "plugin restore";
            desc = "Restore deleted files";
          }
          {
            on = ["T"];
            run = "search --via=rg";
            desc = "Search files by content using ripgrep";
          }
          {
            on = ["t"];
            run = "search --via=fd";
            desc = "Search files by name using fd";
          }
          {
            on = ["C"];
            run = "plugin ouch --args=zip";
            desc = "Compress with ouch";
          }
          {
            on = ["h"];
            run = ["leave" "escape --visual --select"];
            desc = "Parent directory";
          }
          {
            on = ["l"];
            run = "plugin --sync smart-enter";
            desc = "Child directory or open file";
          }
          {
            on = ["q"];
            run = "close";
            desc = "Close tab or quit if last tab";
          }
          {
            on = ["<C-Space>"];
            run = "close";
            desc = "Close tab or quit if last tab";
          }
          {
            on = ["Q"];
            run = "quit --no-cwd-file";
            desc = "Quit without writing cwd file";
          }
          {
            on = ["M"];
            run = "plugin mount";
            desc = "Mount";
          }
          {
            on = ["<C-y>"];
            run = ''shell -- for path in %s; do echo "file://$path"; done | wl-copy -t text/uri-list'';
            desc = "Copy selected files as file:// URI list";
          }
          {
            on = ["Y"];
            run = "unyank";
            desc = "Cancel yank";
          }
          {
            on = ["R"];
            run = "shell -- ripdrag -x %s";
            desc = "Drag files with ripdrag";
          }
          {
            on = ["i"];
            run = "shell -- lnmv %s1";
            desc = "Rename with lnmv";
          }
          {
            on = ["f"];
            run = "plugin smart-filter";
            desc = "Smart filter";
          }
          {
            on = ["m"];
            run = "plugin toggle-pane max-preview";
            desc = "Maximize preview pane";
          }
          {
            on = ["w"];
            run = "plugin toggle-pane min-preview";
            desc = "Minimize preview pane";
          }
          {
            on = ["c"];
            run = "plugin chmod";
            desc = "Change mode";
          }
          {
            on = ["?"];
            run = "help";
            desc = "Open help";
          }
          {
            on = ["r"];
            run = "rename";
            desc = "Rename";
          }
          {
            on = ["e"];
            run = "open";
            desc = "Open selected files";
          }
          {
            on = ["o"];
            run = "open --interactive";
            desc = "Open selected files interactively";
          }
          {
            on = ["s" "s"];
            run = "linemode size";
            desc = "Line mode: size";
          }
          {
            on = ["s" "p"];
            run = "linemode permissions";
            desc = "Line mode: permissions";
          }
          {
            on = ["s" "m"];
            run = "linemode mtime";
            desc = "Line mode: mtime";
          }
          {
            on = ["s" "n"];
            run = "linemode none";
            desc = "Line mode: none";
          }
          {
            on = ["<C-c>"];
            run = "copy path";
            desc = "Copy absolute path";
          }
          {
            on = ["," "m"];
            run = "sort mtime --dir-first";
            desc = "Sort by mtime";
          }
          {
            on = ["," "M"];
            run = "sort mtime --reverse --dir-first";
            desc = "Sort by mtime reverse";
          }
          {
            on = ["," "c"];
            run = "sort btime --dir-first";
            desc = "Sort by created time";
          }
          {
            on = ["," "C"];
            run = "sort btime --reverse --dir-first";
            desc = "Sort by created time reverse";
          }
          {
            on = ["," "e"];
            run = "sort extension --dir-first";
            desc = "Sort by extension";
          }
          {
            on = ["," "E"];
            run = "sort extension --reverse --dir-first";
            desc = "Sort by extension reverse";
          }
          {
            on = ["," "a"];
            run = "sort alphabetical --dir-first";
            desc = "Sort alphabetically";
          }
          {
            on = ["," "A"];
            run = "sort alphabetical --reverse --dir-first";
            desc = "Sort alphabetically reverse";
          }
          {
            on = ["," "n"];
            run = "sort natural --dir-first";
            desc = "Sort naturally";
          }
          {
            on = ["," "N"];
            run = "sort natural --reverse --dir-first";
            desc = "Sort naturally reverse";
          }
          {
            on = ["," "s"];
            run = "sort size --dir-first";
            desc = "Sort by size";
          }
          {
            on = ["," "S"];
            run = "sort size --reverse --dir-first";
            desc = "Sort by size reverse";
          }
          {
            on = ["L"];
            run = "tasks:show";
            desc = "Show task manager";
          }
          {
            on = ["g" "h"];
            run = "cd ~";
            desc = "Go home";
          }
          {
            on = ["g" "c"];
            run = "cd ~/.config";
            desc = "Go config";
          }
          {
            on = ["g" "d"];
            run = "cd ~/dl";
            desc = "Go downloads";
          }
          {
            on = ["g" "t"];
            run = "cd /tmp";
            desc = "Go temporary";
          }
          {
            on = ["g" "n"];
            run = "cd ~/nix";
            desc = "Go nix";
          }
          {
            on = ["n"];
            run = "create";
            desc = "Create a file or directory";
          }
        ];

        input.prepend_keymap = [
          {
            on = ["<Enter>"];
            run = "close --submit";
            desc = "Submit input";
          }
          {
            on = ["<Esc>"];
            run = "close";
            desc = "Cancel input";
          }
          {
            on = ["<Right>"];
            run = "move 1";
            desc = "Move forward a character";
          }
          {
            on = ["<Left>"];
            run = "move -1";
            desc = "Move back a character";
          }
          {
            on = ["<Backspace>"];
            run = "backspace";
            desc = "Delete character before cursor";
          }
          {
            on = ["<Delete>"];
            run = "backspace --under";
            desc = "Delete character under cursor";
          }
          {
            on = ["<C-z>"];
            run = "undo";
            desc = "Undo";
          }
          {
            on = ["<C-y>"];
            run = "redo";
            desc = "Redo";
          }
        ];

        pick.prepend_keymap = [
          {
            on = ["q"];
            run = "close";
            desc = "Cancel selection";
          }
          {
            on = ["o"];
            run = "close";
            desc = "Cancel selection";
          }
          {
            on = ["<Enter>"];
            run = "close --submit";
            desc = "Submit selection";
          }
          {
            on = ["l"];
            run = "close --submit";
            desc = "Submit selection";
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
            on = ["?"];
            run = "help";
            desc = "Open help";
          }
        ];

        tasks.prepend_keymap = [
          {
            on = ["q"];
            run = "close";
            desc = "Hide task manager";
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
            on = ["<Enter>"];
            run = "inspect";
            desc = "Inspect task";
          }
          {
            on = ["d"];
            run = "cancel";
            desc = "Cancel task";
          }
          {
            on = ["?"];
            run = "help";
            desc = "Open help";
          }
        ];

        help.prepend_keymap = [
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
            run = "close";
            desc = "Close help";
          }
          {
            on = ["f"];
            run = "filter";
            desc = "Filter help";
          }
        ];
      };
    };
  };
}
