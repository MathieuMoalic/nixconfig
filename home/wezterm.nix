{
  flake.homeModules.wezterm = {
    config,
    lib,
    pkgs,
    ...
  }: let
    theme = config.colorScheme.palette;
    lua = lib.generators.mkLuaInline;

    mkKey = key: mods: action: {
      inherit key mods;
      action = lua action;
    };

    # Only expose concrete SSH hosts declared in Home Manager.
    #
    # This avoids system SSH aliases such as `.host` and
    # `machine/.host` showing up in WezTerm.
    sshHostNames =
      builtins.filter
      (
        name:
          name
          != "*"
          && !(lib.hasInfix "*" name)
          && !(lib.hasInfix "?" name)
          && !(lib.hasPrefix "!" name)
          && !(lib.hasInfix " " name)
      )
      (builtins.attrNames config.programs.ssh.settings);

    # We keep both kinds of SSH domains:
    #
    # SSH:<host>
    #   Normal, non-persistent SSH.
    #
    # SSHMUX:<host>
    #   Persistent remote WezTerm mux.
    sshDomains =
      lib.concatMap
      (host: [
        {
          name = "SSH:${host}";
          remote_address = host;
          multiplexing = "None";
        }

        {
          name = "SSHMUX:${host}";
          remote_address = host;
          multiplexing = "WezTerm";
        }
      ])
      sshHostNames;

    # Domains shown in our custom Alt+M mux menu.
    #
    # Normal `local` and non-persistent SSH domains are intentionally
    # not included.
    persistentDomains =
      [
        {
          name = "local-mux";
          label = "local-mux";
        }
      ]
      ++ map
      (host: {
        name = "SSHMUX:${host}";
        label = host;
      })
      sshHostNames;

    persistentDomainsLua =
      lib.generators.toLua {} persistentDomains;
  in {
    programs.fish.interactiveShellInit = ''
      if set -q WEZTERM_PANE
        function __wezterm_set_user_var --argument-names name value
          set -l b64 (printf '%s' "$value" | base64 | tr -d '\n')
          printf '\e]1337;SetUserVar=%s=%s\a' "$name" "$b64"
        end

        function __wezterm_set_prog --on-event fish_preexec
          __wezterm_set_user_var WEZTERM_PROG "$argv[1]"
        end
      end
    '';

    programs.wezterm = {
      enable = true;
      package = pkgs.wezterm;

      settings = {
        font =
          lua ''wezterm.font("FiraCode Nerd Font Mono")'';

        font_size = 13.0;

        window_background_opacity = 0.95;

        default_cursor_style = "BlinkingBar";
        cursor_thickness = "2.5px";

        enable_wayland = true;
        window_close_confirmation = "NeverPrompt";

        # Fish OSC 133 semantic zones are used by Ctrl+O.
        default_prog = [
          "${pkgs.fish}/bin/fish"
          "--features"
          "mark-prompt"
          "-l"
        ];

        # A normal WezTerm launch remains a disposable,
        # independent local terminal.
        default_gui_startup_args = [
          "start"
          "--always-new-process"
        ];

        # Persistent local mux.
        unix_domains = [
          {
            name = "local-mux";
          }
        ];

        # Explicit SSH domains derived only from the hosts we manage.
        ssh_domains = sshDomains;

        enable_tab_bar = true;
        hide_tab_bar_if_only_one_tab = false;
        use_fancy_tab_bar = false;

        show_new_tab_button_in_tab_bar = false;
        show_tab_index_in_tab_bar = true;
        tab_max_width = 32;

        scrollback_lines = 10000;

        # Preserve the original colors exactly.
        #
        # In particular, there are intentionally no explicit
        # selection_bg / selection_fg overrides.
        colors = {
          foreground = theme.base05;
          background = theme.base00;

          cursor_border = theme.base05;
          cursor_bg = theme.base05;
          cursor_fg = theme.base00;

          ansi = [
            theme.base00
            theme.base08
            theme.base0B
            theme.base0A
            theme.base0D
            theme.base0E
            theme.base0C
            theme.base05
          ];

          brights = [
            theme.base03
            theme.base09
            theme.base01
            theme.base02
            theme.base04
            theme.base06
            theme.base0F
            theme.base07
          ];

          tab_bar = {
            background = "#000000";

            active_tab = {
              bg_color = theme."hx-current-line";
              fg_color = theme.base05;
            };

            inactive_tab = {
              bg_color = theme.base00;
              fg_color = theme.base03;
            };

            inactive_tab_hover = {
              bg_color = theme."hx-current-line";
              fg_color = theme.base05;
            };

            new_tab = {
              bg_color = theme.base00;
              fg_color = theme.base03;
            };

            new_tab_hover = {
              bg_color = theme."hx-current-line";
              fg_color = theme.base05;
            };
          };
        };

        keys = [
          # -----------------------------------------------------------------------
          # Clipboard / shell helpers
          # -----------------------------------------------------------------------

          (mkKey
            "v"
            "CTRL"
            ''wezterm.action.PasteFrom("Clipboard")'')

          (mkKey
            "Backspace"
            "CTRL"
            ''wezterm.action.SendKey({ key = "w", mods = "CTRL" })'')

          (mkKey
            "o"
            "CTRL"
            ''wezterm.action.EmitEvent("copy-last-command-and-output")'')

          # -----------------------------------------------------------------------
          # Search / rename / copy
          # -----------------------------------------------------------------------

          (mkKey
            "s"
            "ALT|SHIFT"
            ''wezterm.action.Search({ CaseSensitiveString = "" })'')

          (mkKey
            "r"
            "ALT|SHIFT"
            ''wezterm.action.EmitEvent("rename-tab")'')

          (mkKey
            "c"
            "ALT|SHIFT"
            "wezterm.action.ActivateCopyMode")

          # -----------------------------------------------------------------------
          # Mux / workspace manager
          # -----------------------------------------------------------------------

          (mkKey
            "m"
            "ALT"
            ''wezterm.action.EmitEvent("show-mux-menu")'')

          # -----------------------------------------------------------------------
          # Cycle tabs
          # -----------------------------------------------------------------------

          (mkKey
            "Tab"
            "ALT"
            "wezterm.action.ActivateTabRelative(1)")

          (mkKey
            "Tab"
            "ALT|SHIFT"
            "wezterm.action.ActivateTabRelative(-1)")

          # -----------------------------------------------------------------------
          # Pane focus
          # -----------------------------------------------------------------------

          (mkKey
            "h"
            "ALT"
            ''wezterm.action.ActivatePaneDirection("Left")'')

          (mkKey
            "j"
            "ALT"
            ''wezterm.action.ActivatePaneDirection("Down")'')

          (mkKey
            "k"
            "ALT"
            ''wezterm.action.ActivatePaneDirection("Up")'')

          (mkKey
            "l"
            "ALT"
            ''wezterm.action.ActivatePaneDirection("Right")'')

          # -----------------------------------------------------------------------
          # Pane resizing
          # -----------------------------------------------------------------------

          (mkKey
            "h"
            "ALT|SHIFT"
            ''wezterm.action.AdjustPaneSize({ "Left", 3 })'')

          (mkKey
            "j"
            "ALT|SHIFT"
            ''wezterm.action.AdjustPaneSize({ "Down", 3 })'')

          (mkKey
            "k"
            "ALT|SHIFT"
            ''wezterm.action.AdjustPaneSize({ "Up", 3 })'')

          (mkKey
            "l"
            "ALT|SHIFT"
            ''wezterm.action.AdjustPaneSize({ "Right", 3 })'')

          # -----------------------------------------------------------------------
          # Pane management
          # -----------------------------------------------------------------------

          (mkKey
            "a"
            "ALT"
            "wezterm.action.CloseCurrentPane({ confirm = false })")

          (mkKey
            "b"
            "ALT"
            "wezterm.action.TogglePaneZoomState")

          (mkKey
            "o"
            "ALT"
            ''wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" })'')

          (mkKey
            "u"
            "ALT"
            ''wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" })'')

          (mkKey
            "i"
            "ALT"
            ''wezterm.action.PaneSelect({ mode = "Activate", show_pane_ids = true })'')

          (mkKey
            "p"
            "ALT"
            ''wezterm.action.PaneSelect({ mode = "SwapWithActiveKeepFocus", show_pane_ids = true })'')

          # -----------------------------------------------------------------------
          # Tab management
          # -----------------------------------------------------------------------

          (mkKey
            "n"
            "ALT"
            ''wezterm.action.SpawnTab("CurrentPaneDomain")'')

          (mkKey
            "q"
            "ALT"
            "wezterm.action.CloseCurrentTab({ confirm = false })")

          (mkKey
            "t"
            "ALT"
            "wezterm.action.MoveTabRelative(-1)")

          (mkKey
            "y"
            "ALT"
            "wezterm.action.MoveTabRelative(1)")

          # -----------------------------------------------------------------------
          # Detach current mux
          # -----------------------------------------------------------------------

          (mkKey
            "z"
            "ALT"
            ''wezterm.action.DetachDomain("CurrentPaneDomain")'')

          # -----------------------------------------------------------------------
          # Direct tab selection
          # -----------------------------------------------------------------------

          (mkKey
            "w"
            "ALT"
            "wezterm.action.ActivateTab(0)")

          (mkKey
            "e"
            "ALT"
            "wezterm.action.ActivateTab(1)")

          (mkKey
            "r"
            "ALT"
            "wezterm.action.ActivateTab(2)")

          (mkKey
            "s"
            "ALT"
            "wezterm.action.ActivateTab(3)")

          (mkKey
            "d"
            "ALT"
            "wezterm.action.ActivateTab(4)")

          (mkKey
            "f"
            "ALT"
            "wezterm.action.ActivateTab(5)")

          (mkKey
            "x"
            "ALT"
            "wezterm.action.ActivateTab(6)")

          (mkKey
            "c"
            "ALT"
            "wezterm.action.ActivateTab(7)")

          (mkKey
            "v"
            "ALT"
            "wezterm.action.ActivateTab(8)")

          (mkKey
            "g"
            "ALT"
            "wezterm.action.ActivateTab(9)")
        ];
      };

      # Keep Lua for genuinely dynamic behavior only:
      #
      # - Ctrl+O semantic-zone copying
      # - tab rename callback
      # - custom mux/workspace menu
      # - workspace prompts
      # - dynamic right status
      extraConfig = ''
        local act = wezterm.action

        local persistent_domains = ${persistentDomainsLua}

        ---------------------------------------------------------------------------
        -- Generic helpers
        ---------------------------------------------------------------------------

        local function trim(value)
          if not value then
            return nil
          end

          return value:match("^%s*(.-)%s*$")
        end

        local function workspace_exists(name)
          for _, workspace in ipairs(
            wezterm.mux.get_workspace_names()
          ) do
            if workspace == name then
              return true
            end
          end

          return false
        end

        local function domain_label(name)
          if not name
            or name == ""
            or name == "local"
          then
            return "local"
          end

          local ssh_mux =
            name:match("^SSHMUX:(.+)$")

          if ssh_mux then
            return ssh_mux
          end

          local ssh =
            name:match("^SSH:(.+)$")

          if ssh then
            return "ssh:" .. ssh
          end

          return name
        end

        ---------------------------------------------------------------------------
        -- Copy last command + output
        ---------------------------------------------------------------------------

        local function copy_last_command_and_output(
          window,
          pane
        )
          local outputs =
            pane:get_semantic_zones("Output")
            or {}

          local last_out = nil
          local out_text = ""

          for i = #outputs, 1, -1 do
            local zone = outputs[i]

            local text =
              pane:get_text_from_semantic_zone(
                zone
              )
              or ""

            if text:find("%S") then
              last_out = zone
              out_text = text
              break
            end
          end

          if not last_out then
            window:toast_notification(
              "wezterm",
              "No command output zone found. Restart this Fish shell after rebuilding the config.",
              nil,
              5000
            )

            return
          end

          local cmd_text = ""

          local inputs =
            pane:get_semantic_zones("Input")
            or {}

          for i = #inputs, 1, -1 do
            local zone = inputs[i]

            local zone_end_y =
              zone.end_y or 0

            local zone_end_x =
              zone.end_x or 0

            local output_start_y =
              last_out.start_y or 0

            local output_start_x =
              last_out.start_x or 0

            local ends_before_output =
              zone_end_y < output_start_y
              or (
                zone_end_y == output_start_y
                and zone_end_x <= output_start_x
              )

            if ends_before_output then
              cmd_text =
                pane:get_text_from_semantic_zone(
                  zone
                )
                or ""

              break
            end
          end

          if not cmd_text:find("%S") then
            local vars =
              pane:get_user_vars()
              or {}

            if vars.WEZTERM_PROG
              and vars.WEZTERM_PROG:find("%S")
            then
              cmd_text =
                vars.WEZTERM_PROG
            end
          end

          cmd_text =
            (cmd_text or "")
              :gsub("\r", "")
              :gsub("\n+$", "")

          out_text =
            (out_text or "")
              :gsub("\r", "")
              :gsub("\n+$", "")

          if (cmd_text .. out_text):match(
            "^%s*$"
          ) then
            window:toast_notification(
              "wezterm",
              "Last command/output was empty.",
              nil,
              2000
            )

            return
          end

          local combined

          if cmd_text ~= ""
            and out_text ~= ""
          then
            combined =
              cmd_text
              .. "\n"
              .. out_text
          else
            combined =
              (cmd_text ~= "" and cmd_text)
              or out_text
          end

          window:copy_to_clipboard(
            combined,
            "Clipboard"
          )

          window:toast_notification(
            "wezterm",
            "Copied last command + output to clipboard.",
            nil,
            1500
          )
        end

        wezterm.on(
          "copy-last-command-and-output",
          copy_last_command_and_output
        )

        ---------------------------------------------------------------------------
        -- Rename tab
        ---------------------------------------------------------------------------

        wezterm.on(
          "rename-tab",
          function(window, pane)
            window:perform_action(
              act.PromptInputLine({
                description =
                  "Rename tab:",

                action =
                  wezterm.action_callback(
                    function(
                      inner_window,
                      inner_pane,
                      line
                    )
                      line = trim(line)

                      if not line
                        or line == ""
                      then
                        return
                      end

                      inner_window
                        :active_tab()
                        :set_title(line)
                    end
                  ),
              }),
              pane
            )
          end
        )

        ---------------------------------------------------------------------------
        -- Attach persistent domain
        ---------------------------------------------------------------------------

        local function attach_domain(
          window,
          pane,
          domain_name
        )
          local domain =
            wezterm.mux.get_domain(
              domain_name
            )

          if not domain then
            window:toast_notification(
              "wezterm",
              "Unknown mux domain: "
                .. domain_name,
              nil,
              3000
            )

            return
          end

          if domain:state() == "Attached" then
            window:toast_notification(
              "wezterm",
              domain_label(domain_name)
                .. " is already attached. Use Switch workspace to select one of its workspaces.",
              nil,
              3000
            )

            return
          end

          window:perform_action(
            act.AttachDomain(
              domain_name
            ),
            pane
          )
        end

        ---------------------------------------------------------------------------
        -- Switch workspace
        ---------------------------------------------------------------------------

        local function show_workspace_selector(
          window,
          pane
        )
          local workspaces =
            wezterm.mux.get_workspace_names()

          table.sort(workspaces)

          local active =
            window:active_workspace()

          local choices = {}

          for _, workspace in ipairs(
            workspaces
          ) do
            local label = workspace

            if workspace == active then
              label =
                workspace
                .. "  [current]"
            end

            table.insert(
              choices,
              {
                id = workspace,
                label = label,
              }
            )
          end

          if #choices == 0 then
            window:toast_notification(
              "wezterm",
              "No workspaces are available.",
              nil,
              2000
            )

            return
          end

          window:perform_action(
            act.InputSelector({
              title =
                "Switch workspace",

              choices =
                choices,

              fuzzy =
                true,

              fuzzy_description =
                "Workspace: ",

              action =
                wezterm.action_callback(
                  function(
                    inner_window,
                    inner_pane,
                    id,
                    label
                  )
                    if not id then
                      return
                    end

                    inner_window
                      :perform_action(
                        act.SwitchToWorkspace({
                          name = id,
                        }),
                        inner_pane
                      )
                  end
                ),
            }),
            pane
          )
        end

        ---------------------------------------------------------------------------
        -- Create named workspace
        ---------------------------------------------------------------------------

        local function prompt_create_workspace(
          window,
          pane
        )
          -- Capture the domain BEFORE opening the prompt overlay.
          --
          -- The new workspace will therefore be created in whichever
          -- domain the user was actually working in:
          --
          -- local
          -- local-mux
          -- SSHMUX:homeserver
          -- etc.
          local source_domain =
            pane:get_domain_name()

          window:perform_action(
            act.PromptInputLine({
              description =
                "Create workspace in "
                .. domain_label(
                  source_domain
                )
                .. ":",

              action =
                wezterm.action_callback(
                  function(
                    inner_window,
                    inner_pane,
                    line
                  )
                    line = trim(line)

                    if not line
                      or line == ""
                    then
                      return
                    end

                    if workspace_exists(line) then
                      inner_window
                        :toast_notification(
                          "wezterm",
                          "Workspace already exists: "
                            .. line,
                          nil,
                          2500
                        )

                      return
                    end

                    inner_window
                      :perform_action(
                        act.SwitchToWorkspace({
                          name = line,

                          spawn = {
                            domain = {
                              DomainName =
                                source_domain,
                            },
                          },
                        }),
                        inner_pane
                      )
                  end
                ),
            }),
            pane
          )
        end

        ---------------------------------------------------------------------------
        -- Rename current workspace
        ---------------------------------------------------------------------------

        local function prompt_rename_workspace(
          window,
          pane
        )
          local current =
            window:active_workspace()

          window:perform_action(
            act.PromptInputLine({
              description =
                "Rename workspace \""
                .. current
                .. "\":",

              action =
                wezterm.action_callback(
                  function(
                    inner_window,
                    inner_pane,
                    line
                  )
                    line = trim(line)

                    if not line
                      or line == ""
                      or line == current
                    then
                      return
                    end

                    if workspace_exists(line) then
                      inner_window
                        :toast_notification(
                          "wezterm",
                          "Workspace already exists: "
                            .. line,
                          nil,
                          2500
                        )

                      return
                    end

                    local ok, err =
                      pcall(
                        wezterm.mux
                          .rename_workspace,
                        current,
                        line
                      )

                    if not ok then
                      inner_window
                        :toast_notification(
                          "wezterm",
                          "Failed to rename workspace: "
                            .. tostring(err),
                          nil,
                          4000
                        )
                    end
                  end
                ),
            }),
            pane
          )
        end

        ---------------------------------------------------------------------------
        -- Custom Alt+M mux/workspace menu
        ---------------------------------------------------------------------------

        local function show_mux_menu(
          window,
          pane
        )
          local choices = {}

          for _, domain_info in ipairs(
            persistent_domains
          ) do
            local domain =
              wezterm.mux.get_domain(
                domain_info.name
              )

            local label =
              "Attach "
              .. domain_info.label

            if domain
              and domain:state()
                == "Attached"
            then
              label =
                domain_info.label
                .. "  [attached]"
            end

            table.insert(
              choices,
              {
                id =
                  "domain:"
                  .. domain_info.name,

                label =
                  label,
              }
            )
          end

          local active_workspace =
            window:active_workspace()

          local current_domain =
            domain_label(
              pane:get_domain_name()
            )

          table.insert(
            choices,
            {
              id =
                "workspace:switch",

              label =
                "Switch workspace"
                .. "  ["
                .. active_workspace
                .. "]",
            }
          )

          table.insert(
            choices,
            {
              id =
                "workspace:create",

              label =
                "Create workspace"
                .. "  ["
                .. current_domain
                .. "]",
            }
          )

          table.insert(
            choices,
            {
              id =
                "workspace:rename",

              label =
                "Rename workspace"
                .. "  ["
                .. active_workspace
                .. "]",
            }
          )

          window:perform_action(
            act.InputSelector({
              title =
                "Mux / Workspaces",

              choices =
                choices,

              fuzzy =
                true,

              fuzzy_description =
                "Mux / Workspace: ",

              action =
                wezterm.action_callback(
                  function(
                    inner_window,
                    inner_pane,
                    id,
                    label
                  )
                    if not id then
                      return
                    end

                    local domain_name =
                      id:match(
                        "^domain:(.+)$"
                      )

                    if domain_name then
                      attach_domain(
                        inner_window,
                        inner_pane,
                        domain_name
                      )

                      return
                    end

                    if id
                      == "workspace:switch"
                    then
                      show_workspace_selector(
                        inner_window,
                        inner_pane
                      )

                      return
                    end

                    if id
                      == "workspace:create"
                    then
                      prompt_create_workspace(
                        inner_window,
                        inner_pane
                      )

                      return
                    end

                    if id
                      == "workspace:rename"
                    then
                      prompt_rename_workspace(
                        inner_window,
                        inner_pane
                      )
                    end
                  end
                ),
            }),
            pane
          )
        end

        wezterm.on(
          "show-mux-menu",
          show_mux_menu
        )

        ---------------------------------------------------------------------------
        -- Right status
        ---------------------------------------------------------------------------

        wezterm.on(
          "update-right-status",
          function(window, pane)
            local label =
              domain_label(
                pane:get_domain_name()
              )

            local workspace =
              window:active_workspace()

            if workspace
              and workspace ~= ""
              and workspace ~= "default"
            then
              label =
                label
                .. ":"
                .. workspace
            end

            window:set_right_status(
              wezterm.format({
                {
                  Foreground = {
                    Color =
                      "${theme.base03}",
                  },
                },
                {
                  Text =
                    "  ["
                    .. label
                    .. "]  ",
                },
              })
            )
          end
        )
      '';
    };
  };
}
