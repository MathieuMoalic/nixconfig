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

    # Keep both SSH domain types configured:
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

    # Remote persistent domains used by the custom Alt+M menu.
    # `local-mux` is added in Lua so it can be labeled with the
    # runtime hostname.
    remoteMuxDomains =
      map
      (host: {
        name = "SSHMUX:${host}";
        label = host;
      })
      sshHostNames;

    remoteMuxDomainsLua =
      lib.generators.toLua {} remoteMuxDomains;

    # WezTerm has no Lua API for removing an arbitrary mux pane.
    # Use the mux server's CLI directly so workspace deletion is scoped
    # to the selected persistent domain rather than whichever GUI pane
    # happens to be active.
    deleteWorkspace = pkgs.writeShellScript "wezterm-delete-workspace" ''
      set -euo pipefail

      domain="$1"
      workspace="$2"

      if [ "$domain" = "local-mux" ]; then
        pane_ids="$(${pkgs.wezterm}/bin/wezterm cli --prefer-mux list --format json \
          | ${pkgs.jq}/bin/jq -r --arg workspace "$workspace" \
            '.[] | select(.workspace == $workspace) | .pane_id')"

        if [ -z "$pane_ids" ]; then
          echo "No panes found in workspace: $workspace" >&2
          exit 2
        fi

        printf '%s\n' "$pane_ids" | while IFS= read -r pane_id; do
          ${pkgs.wezterm}/bin/wezterm cli --prefer-mux kill-pane --pane-id "$pane_id"
        done

        exit 0
      fi

      case "$domain" in
        SSHMUX:*)
          host="''${domain#SSHMUX:}"
          ;;
        *)
          echo "Unsupported persistent domain: $domain" >&2
          exit 3
          ;;
      esac

      pane_ids="$(${pkgs.openssh}/bin/ssh "$host" wezterm cli --prefer-mux list --format json \
        | ${pkgs.jq}/bin/jq -r --arg workspace "$workspace" \
          '.[] | select(.workspace == $workspace) | .pane_id')"

      if [ -z "$pane_ids" ]; then
        echo "No panes found in workspace: $workspace" >&2
        exit 2
      fi

      printf '%s\n' "$pane_ids" | while IFS= read -r pane_id; do
        ${pkgs.openssh}/bin/ssh "$host" wezterm cli --prefer-mux kill-pane --pane-id "$pane_id"
      done
    '';
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

        enable_wayland = false;
        window_close_confirmation = "NeverPrompt";

        # Fish OSC 133 semantic zones are used by Ctrl+O.
        default_prog = [
          "${pkgs.fish}/bin/fish"
          "--features"
          "mark-prompt"
          "-l"
        ];

        # A normal launch is deliberately disposable and gets its own
        # built-in `local` mux. Named workspaces live in persistent domains.
        default_gui_startup_args = [
          "start"
          "--always-new-process"
        ];

        unix_domains = [
          {
            name = "local-mux";
          }
        ];

        ssh_domains = sshDomains;

        enable_tab_bar = true;
        hide_tab_bar_if_only_one_tab = false;
        use_fancy_tab_bar = false;
        show_new_tab_button_in_tab_bar = false;
        show_tab_index_in_tab_bar = true;
        tab_max_width = 32;

        scrollback_lines = 10000;

        # Preserve the original colors exactly. In particular, there are
        # intentionally no explicit selection_bg / selection_fg overrides.
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
          # Clipboard / shell helpers.
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

          # Search / rename / copy.
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

          # Mux / workspace manager.
          (mkKey
            "m"
            "ALT"
            ''wezterm.action.EmitEvent("show-mux-menu")'')

          # Cycle tabs.
          (mkKey
            "Tab"
            "ALT"
            "wezterm.action.ActivateTabRelative(1)")

          (mkKey
            "Tab"
            "ALT|SHIFT"
            "wezterm.action.ActivateTabRelative(-1)")

          # Pane focus.
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

          # Pane resizing.
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

          # Pane management.
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

          # Tab management.
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

          # Detach current mux.
          (mkKey
            "z"
            "ALT"
            ''wezterm.action.DetachDomain("CurrentPaneDomain")'')

          # Direct tab selection.
          (mkKey "w" "ALT" "wezterm.action.ActivateTab(0)")
          (mkKey "e" "ALT" "wezterm.action.ActivateTab(1)")
          (mkKey "r" "ALT" "wezterm.action.ActivateTab(2)")
          (mkKey "s" "ALT" "wezterm.action.ActivateTab(3)")
          (mkKey "d" "ALT" "wezterm.action.ActivateTab(4)")
          (mkKey "f" "ALT" "wezterm.action.ActivateTab(5)")
          (mkKey "x" "ALT" "wezterm.action.ActivateTab(6)")
          (mkKey "c" "ALT" "wezterm.action.ActivateTab(7)")
          (mkKey "v" "ALT" "wezterm.action.ActivateTab(8)")
          (mkKey "g" "ALT" "wezterm.action.ActivateTab(9)")
        ];
      };

      # Keep Lua for genuinely dynamic behavior only:
      #
      # - Ctrl+O semantic-zone copying
      # - tab rename callback
      # - domain/workspace discovery
      # - custom Alt+M menus and prompts
      # - dynamic right status
      extraConfig = ''
        local act = wezterm.action

        local remote_mux_domains = ${remoteMuxDomainsLua}

        local hostname = wezterm.hostname()
        local short_hostname =
          hostname:match("^([^.]+)") or hostname

        ---------------------------------------------------------------------------
        -- Generic helpers
        ---------------------------------------------------------------------------

        local function trim(value)
          if not value then
            return nil
          end

          return value:match("^%s*(.-)%s*$")
        end

        local function short_host(value)
          if not value then
            return nil
          end

          return value:match("^([^.]+)") or value
        end

        local function same_host(left, right)
          if not left or not right then
            return false
          end

          return short_host(left):lower()
            == short_host(right):lower()
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
          if not name or name == "" or name == "local" then
            return "local"
          end

          if name == "local-mux" then
            return short_hostname
          end

          local ssh_mux = name:match("^SSHMUX:(.+)$")

          if ssh_mux then
            return ssh_mux
          end

          local ssh = name:match("^SSH:(.+)$")

          if ssh then
            return "ssh:" .. ssh
          end

          return name
        end

        local function mux_window_has_domain(
          mux_window,
          domain_name
        )
          for _, tab in ipairs(mux_window:tabs()) do
            for _, candidate in ipairs(tab:panes()) do
              if candidate:get_domain_name() == domain_name then
                return true
              end
            end
          end

          return false
        end

        local function workspaces_for_domain(domain_name)
          local seen = {}
          local workspaces = {}

          for _, mux_window in ipairs(
            wezterm.mux.all_windows()
          ) do
            local workspace = mux_window:get_workspace()

            if workspace
              and workspace ~= ""
              and not seen[workspace]
              and mux_window_has_domain(
                mux_window,
                domain_name
              )
            then
              seen[workspace] = true
              table.insert(workspaces, workspace)
            end
          end

          table.sort(workspaces)
          return workspaces
        end

        local function get_domain(window, domain_name)
          local domain = wezterm.mux.get_domain(domain_name)

          if domain then
            return domain
          end

          window:toast_notification(
            "wezterm",
            "Unknown mux domain: " .. domain_name,
            nil,
            3000
          )

          return nil
        end

        local function ensure_domain_attached(
          window,
          domain_name
        )
          local domain = get_domain(window, domain_name)

          if not domain then
            return false
          end

          if domain:state() == "Attached" then
            return true
          end

          local ok, err = pcall(function()
            domain:attach()
          end)

          if not ok then
            window:toast_notification(
              "wezterm",
              "Failed to attach "
                .. domain_label(domain_name)
                .. ": "
                .. tostring(err),
              nil,
              5000
            )

            return false
          end

          if domain:state() ~= "Attached" then
            window:toast_notification(
              "wezterm",
              "Could not attach "
                .. domain_label(domain_name),
              nil,
              4000
            )

            return false
          end

          return true
        end

        ---------------------------------------------------------------------------
        -- Copy last command + output
        ---------------------------------------------------------------------------

        local function copy_last_command_and_output(
          window,
          pane
        )
          local outputs =
            pane:get_semantic_zones("Output") or {}

          local last_out = nil
          local out_text = ""

          for i = #outputs, 1, -1 do
            local zone = outputs[i]
            local text =
              pane:get_text_from_semantic_zone(zone) or ""

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
          local inputs = pane:get_semantic_zones("Input") or {}

          for i = #inputs, 1, -1 do
            local zone = inputs[i]
            local zone_end_y = zone.end_y or 0
            local zone_end_x = zone.end_x or 0
            local output_start_y = last_out.start_y or 0
            local output_start_x = last_out.start_x or 0

            local ends_before_output =
              zone_end_y < output_start_y
              or (
                zone_end_y == output_start_y
                and zone_end_x <= output_start_x
              )

            if ends_before_output then
              cmd_text =
                pane:get_text_from_semantic_zone(zone) or ""
              break
            end
          end

          if not cmd_text:find("%S") then
            local vars = pane:get_user_vars() or {}

            if vars.WEZTERM_PROG
              and vars.WEZTERM_PROG:find("%S")
            then
              cmd_text = vars.WEZTERM_PROG
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

          if (cmd_text .. out_text):match("^%s*$") then
            window:toast_notification(
              "wezterm",
              "Last command/output was empty.",
              nil,
              2000
            )

            return
          end

          local combined

          if cmd_text ~= "" and out_text ~= "" then
            combined = cmd_text .. "\n" .. out_text
          else
            combined =
              (cmd_text ~= "" and cmd_text) or out_text
          end

          window:copy_to_clipboard(combined, "Clipboard")

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
                description = "Rename tab:",

                action = wezterm.action_callback(
                  function(
                    inner_window,
                    inner_pane,
                    line
                  )
                    line = trim(line)

                    if not line or line == "" then
                      return
                    end

                    inner_window:active_tab():set_title(line)
                  end
                ),
              }),
              pane
            )
          end
        )

        ---------------------------------------------------------------------------
        -- Workspace selectors and actions
        ---------------------------------------------------------------------------

        local function choose_workspace(
          window,
          pane,
          domain_name,
          title,
          callback
        )
          local workspaces =
            workspaces_for_domain(domain_name)

          if #workspaces == 0 then
            window:toast_notification(
              "wezterm",
              "No workspaces in "
                .. domain_label(domain_name)
                .. ".",
              nil,
              2500
            )

            return
          end

          local current = window:active_workspace()
          local choices = {}

          for _, workspace in ipairs(workspaces) do
            local label = workspace

            if workspace == current then
              label = workspace .. "  [current]"
            end

            table.insert(
              choices,
              {
                id = workspace,
                label = label,
              }
            )
          end

          window:perform_action(
            act.InputSelector({
              title = title,
              choices = choices,
              fuzzy = true,
              fuzzy_description = "Workspace: ",

              action = wezterm.action_callback(
                function(
                  inner_window,
                  inner_pane,
                  id,
                  label
                )
                  if not id then
                    return
                  end

                  callback(
                    inner_window,
                    inner_pane,
                    id
                  )
                end
              ),
            }),
            pane
          )
        end

        local function switch_workspace(
          window,
          pane,
          domain_name
        )
          choose_workspace(
            window,
            pane,
            domain_name,
            "Switch workspace · "
              .. domain_label(domain_name),
            function(
              inner_window,
              inner_pane,
              workspace
            )
              inner_window:perform_action(
                act.SwitchToWorkspace({
                  name = workspace,
                }),
                inner_pane
              )
            end
          )
        end

        local function create_workspace(
          window,
          pane,
          domain_name
        )
          window:perform_action(
            act.PromptInputLine({
              description =
                "Create workspace in "
                .. domain_label(domain_name)
                .. ":",

              action = wezterm.action_callback(
                function(
                  inner_window,
                  inner_pane,
                  line
                )
                  line = trim(line)

                  if not line or line == "" then
                    return
                  end

                  if workspace_exists(line) then
                    inner_window:toast_notification(
                      "wezterm",
                      "Workspace already exists: " .. line,
                      nil,
                      2500
                    )

                    return
                  end

                  inner_window:perform_action(
                    act.SwitchToWorkspace({
                      name = line,
                      spawn = {
                        domain = {
                          DomainName = domain_name,
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

        local function rename_workspace(
          window,
          pane,
          domain_name
        )
          choose_workspace(
            window,
            pane,
            domain_name,
            "Rename workspace · "
              .. domain_label(domain_name),
            function(
              inner_window,
              inner_pane,
              workspace
            )
              inner_window:perform_action(
                act.PromptInputLine({
                  description =
                    "Rename workspace \""
                    .. workspace
                    .. "\":",

                  action = wezterm.action_callback(
                    function(
                      prompt_window,
                      prompt_pane,
                      line
                    )
                      line = trim(line)

                      if not line
                        or line == ""
                        or line == workspace
                      then
                        return
                      end

                      if workspace_exists(line) then
                        prompt_window:toast_notification(
                          "wezterm",
                          "Workspace already exists: "
                            .. line,
                          nil,
                          2500
                        )

                        return
                      end

                      local renamed = false

                      for _, mux_window in ipairs(
                        wezterm.mux.all_windows()
                      ) do
                        if mux_window:get_workspace()
                            == workspace
                          and mux_window_has_domain(
                            mux_window,
                            domain_name
                          )
                        then
                          local ok, err = pcall(
                            mux_window.set_workspace,
                            mux_window,
                            line
                          )

                          if not ok then
                            prompt_window:toast_notification(
                              "wezterm",
                              "Failed to rename workspace: "
                                .. tostring(err),
                              nil,
                              4000
                            )

                            return
                          end

                          renamed = true
                        end
                      end

                      if not renamed then
                        prompt_window:toast_notification(
                          "wezterm",
                          "Workspace no longer exists in "
                            .. domain_label(domain_name)
                            .. ": "
                            .. workspace,
                          nil,
                          3000
                        )
                      end
                    end
                  ),
                }),
                inner_pane
              )
            end
          )
        end

        local function delete_workspace_now(
          window,
          domain_name,
          workspace_name
        )
          local success, stdout, stderr =
            wezterm.run_child_process({
              "${deleteWorkspace}",
              domain_name,
              workspace_name,
            })

          if success then
            return
          end

          local message = trim(stderr)

          if not message or message == "" then
            message = trim(stdout)
          end

          if not message or message == "" then
            message =
              "Failed to delete workspace "
              .. workspace_name
          end

          window:toast_notification(
            "wezterm",
            message,
            nil,
            5000
          )
        end

        local function delete_workspace(
          window,
          pane,
          domain_name
        )
          choose_workspace(
            window,
            pane,
            domain_name,
            "Delete workspace · "
              .. domain_label(domain_name),
            function(
              inner_window,
              inner_pane,
              workspace
            )
              delete_workspace_now(
                inner_window,
                domain_name,
                workspace
              )
            end
          )
        end

        ---------------------------------------------------------------------------
        -- Domain -> action -> workspace menu
        ---------------------------------------------------------------------------

        local function show_domain_actions(
          window,
          pane,
          domain_name
        )
          local label = domain_label(domain_name)

          window:perform_action(
            act.InputSelector({
              title = "Mux · " .. label,
              choices = {
                {
                  id = "switch",
                  label = "Switch workspace",
                },
                {
                  id = "create",
                  label = "Create workspace",
                },
                {
                  id = "rename",
                  label = "Rename workspace",
                },
                {
                  id = "delete",
                  label = "Delete workspace",
                },
              },
              fuzzy = false,

              action = wezterm.action_callback(
                function(
                  inner_window,
                  inner_pane,
                  id,
                  selected_label
                )
                  if id == "switch" then
                    switch_workspace(
                      inner_window,
                      inner_pane,
                      domain_name
                    )
                    return
                  end

                  if id == "create" then
                    create_workspace(
                      inner_window,
                      inner_pane,
                      domain_name
                    )
                    return
                  end

                  if id == "rename" then
                    rename_workspace(
                      inner_window,
                      inner_pane,
                      domain_name
                    )
                    return
                  end

                  if id == "delete" then
                    delete_workspace(
                      inner_window,
                      inner_pane,
                      domain_name
                    )
                  end
                end
              ),
            }),
            pane
          )
        end

        local function show_mux_menu(window, pane)
          local choices = {}

          local local_domain =
            wezterm.mux.get_domain("local-mux")

          local local_label = short_hostname .. "  [local]"

          if local_domain
            and local_domain:state() == "Attached"
          then
            local_label = local_label .. "  [attached]"
          end

          table.insert(
            choices,
            {
              id = "local-mux",
              label = local_label,
            }
          )

          for _, domain_info in ipairs(
            remote_mux_domains
          ) do
            if not same_host(
              domain_info.label,
              hostname
            )
            then
              local domain = wezterm.mux.get_domain(
                domain_info.name
              )

              local label =
                domain_info.label .. "  [ssh]"

              if domain
                and domain:state() == "Attached"
              then
                label = label .. "  [attached]"
              end

              table.insert(
                choices,
                {
                  id = domain_info.name,
                  label = label,
                }
              )
            end
          end

          window:perform_action(
            act.InputSelector({
              title = "Mux domains",
              choices = choices,
              fuzzy = true,
              fuzzy_description = "Domain: ",

              action = wezterm.action_callback(
                function(
                  inner_window,
                  inner_pane,
                  domain_name,
                  selected_label
                )
                  if not domain_name then
                    return
                  end

                  if not ensure_domain_attached(
                    inner_window,
                    domain_name
                  )
                  then
                    return
                  end

                  show_domain_actions(
                    inner_window,
                    inner_pane,
                    domain_name
                  )
                end
              ),
            }),
            pane
          )
        end

        wezterm.on("show-mux-menu", show_mux_menu)

        ---------------------------------------------------------------------------
        -- Right status
        ---------------------------------------------------------------------------

        wezterm.on(
          "update-right-status",
          function(window, pane)
            local label =
              domain_label(pane:get_domain_name())

            local workspace = window:active_workspace()

            if workspace
              and workspace ~= ""
              and workspace ~= "default"
            then
              label = label .. ":" .. workspace
            end

            window:set_right_status(
              wezterm.format({
                {
                  Foreground = {
                    Color = "${theme.base03}",
                  },
                },
                {
                  Text = "  [" .. label .. "]  ",
                },
              })
            )
          end
        )
      '';
    };
  };
}
