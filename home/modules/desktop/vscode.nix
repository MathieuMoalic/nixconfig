{...}: {
  home.shellAliases = {
    code = "code --enable-features=UseOzonePlatform --ozone-platform=wayland";
  };
  xdg.configFile."Code/User/keybindings.json".text = ''
    [
        {
            "key": "ctrl+up",
            "command": "editor.action.insertLineBefore",
            "when": "editorTextFocus && !editorReadonly"
        },
        {
            "key": "ctrl+down",
            "command": "editor.action.insertLineAfter",
            "when": "editorTextFocus && !editorReadonly"
        },
        {
            "key": "shift+alt+down",
            "command": "editor.action.copyLinesDownAction",
            "when": "editorTextFocus && !editorReadonly"
        },
        {
            "key": "ctrl+shift+alt+down",
            "command": "-editor.action.copyLinesDownAction",
            "when": "editorTextFocus && !editorReadonly"
        },
        {
            "key": "shift+alt+up",
            "command": "editor.action.copyLinesUpAction",
            "when": "editorTextFocus && !editorReadonly"
        },
        {
            "key": "ctrl+shift+alt+up",
            "command": "-editor.action.copyLinesUpAction",
            "when": "editorTextFocus && !editorReadonly"
        },
        {
            "command": "runCommands",
            "key": "ctrl+s", // whatever keybinding
            "when": "editorLangId == python",
            "args": {
                "commands": [
                    "ruff.executeOrganizeImports",
                    "ruff.executeFormat",
                    "workbench.action.files.save",
                ]
            }
        },
        {
            "command": "runCommands",
            "key": "ctrl+shift+s", // whatever keybinding
            "when": "editorLangId == python",
            "args": {
                "commands": [
                    "ruff.executeAutofix",
                    "ruff.executeOrganizeImports",
                    "ruff.executeFormat",
                    "workbench.action.files.save",
                ]
            }
        }
    }
  '';
  xdg.configFile."Code/User/settings.json".text = ''
    {
      "go.inferGopath": false,
      "files.simpleDialog.enable": true,
      "blender.allowModifyExternalPython": true,
      "css.lint.unknownAtRules": "ignore",
      "search.followSymlinks": false,
      "security.workspace.trust.enabled": false,
      "files.autoSave": "onFocusChange",
      "editor.fontFamily": "FiraCode Nerd Font Mono",
      "editor.fontLigatures": true,
      "editor.suggest.insertMode": "replace",
      "workbench.iconTheme": "material-icon-theme",
      "material-icon-theme.hidesExplorerArrows": true,
      "material-icon-theme.activeIconPack": "react",
      "material-icon-theme.files.associations": {
        "*.zarr": "Database",
        "*.logs": "Yaml",
        "gui": "3d",
        ".z": "Log",
        ".zhistory": "Log",
        ".zshrc_local": "Console",
        "table.txt": "Table",
        "*.mx3": "Sequelize"
      },
      "material-icon-theme.folders.associations": {
        "figs": "Images",
        ".config": "Config",
        ".ssh": "Client",
        ".local": "Config",
        "gh": "Github",
        "dotfiles": "Controller",
        "dl": "Download"
      },
      "explorer.confirmDragAndDrop": false,
      "git.enableSmartCommit": true,
      "git.confirmSync": false,
      "git.autofetch": true,
      "git.ignoreMissingGitWarning": true,
      "files.associations": {
        "template": "go",
        "*.logs": "go",
        "*.html": "html",
        "mplstyle": "python",
        "*.mplstyle": "plaintext",
        ".zattrs": "json",
        ".zgroup": "json",
        ".zarray": "json",
        "*.service": "ini",
        "*.timer": "ini",
        "*.mx3": "mx3"
      },
      "workbench.startupEditor": "newUntitledFile",
      "jupyter.askForKernelRestart": false,
      "search.exclude": {
        "**/__pycache__": true,
        "**/.mypy_cache": true
      },
      "editor.wordWrapColumn": 120,
      "files.exclude": {
        "**/.ruff_cache": true,
        "**/.direnv": true,
        "**/__pycache__": true,
        "**/.ipynb_checkpoints": true,
        "**/.pytest_cache": true,
        "**/*.pyc": true,
        "**/dask-worker-space": true,
        "**/node_modules": true,
        "**/references.bib": true,
        "**/*.egg-info": true,
        "**/.gnupg": true,
        "**/.nv": true,
        "**/.pki": true,
        "**/.kde4": true,
        "**/.vscode-server": true,
        "**/.gtkrc-2.0": true,
        "**/.lesshst": true,
        "**/.Xauthority": true,
        "**/.jupyter": true,
        "**/.ipython": true,
        "**/.z": true,
        "**/.Trash-1000": true,
        "**/.virtual_documents": true,
        "**/.mypy_cache": true
      },
      "extensions.ignoreRecommendations": true,
      "diffEditor.wordWrap": "off",
      "python.terminal.activateEnvInCurrentTerminal": true,
      "notebook.cellToolbarLocation": {
        "default": "right",
        "jupyter-notebook": "left"
      },
      "python.languageServer": "Pylance",
      "security.workspace.trust.untrustedFiles": "open",
      "workbench.editorAssociations": {
        "*.ipynb": "jupyter-notebook"
      },
      "editor.minimap.enabled": false,
      "workbench.colorCustomizations": {
        "statusBar.background": "#005f5f",
        "statusBar.noFolderBackground": "#005f5f",
        "statusBar.debuggingBackground": "#005f5f"
      },
      "files.watcherExclude": {
        "**/*.ovf": true,
        "**/*.out": true,
        "**/*.zarr": true
      },
      "explorer.confirmDelete": false,
      "notebook.cellToolbarVisibility": "hover",
      "notebook.consolidatedOutputButton": false,
      "security.workspace.trust.banner": "never",
      "security.workspace.trust.startupPrompt": "never",
      "notebook.diff.ignoreMetadata": true,
      "notebook.diff.ignoreOutputs": true,
      "notebook.navigation.allowNavigateToSurroundingCells": false,
      "notebook.showCellStatusBar": "visibleAfterExecute",
      "editor.bracketPairColorization.enabled": true,
      "editor.suggest.preview": true,
      "breadcrumbs.enabled": false,
      "editor.acceptSuggestionOnEnter": "off",
      "editor.quickSuggestions": {
        "comments": "on",
        "strings": "on",
        "other": "on"
      },
      "telemetry.telemetryLevel": "off",
      "editor.guides.bracketPairs": true,
      "editor.cursorBlinking": "phase",
      "editor.cursorSmoothCaretAnimation": "on",
      "terminal.integrated.defaultProfile.linux": "zsh",
      "window.title": "''${folderName}",
      "git.decorations.enabled": false,
      "jupyter.widgetScriptSources": [
        "jsdelivr.com",
        "unpkg.com"
      ],
      "svelte.enable-ts-plugin": true,
      "remote.SSH.lockfilesInTmp": true,
      "remote.SSH.localServerDownload": "always",
      "remote.SSH.remotePlatform": {
        "pcss": "linux"
      },
      "workbench.panel.defaultLocation": "right",
      "git.ignoreLegacyWarning": true,
      "scm.diffDecorations": "none",
      "update.mode": "none",
      "gitlens.statusBar.enabled": false,
      "window.menuBarVisibility": "hidden",
      "jupyter.allowUnauthorizedRemoteConnection": true,
      "workbench.colorTheme": "Dracula Theme",
      "editor.fontSize": 15,
      "notebook.lineNumbers": "on",
      "notebook.output.scrolling": true,
      "editor.formatOnSave": true,
      "go.inlayHints.rangeVariableTypes": true,
      "window.zoomLevel": 1,
      "workbench.editor.empty.hint": "hidden",
      "go.toolsManagement.autoUpdate": true,
      "mx3.openWebUI": false,
      "mx3.path": "amumax",
      "python.analysis.autoFormatStrings": true,
      "python.analysis.autoImportCompletions": true,
      "git.openRepositoryInParentFolders": "never"
    }
  '';
}
