{inputs, ...}: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index # weekly nix-index refresh
  ];
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
  programs.nushell = {
    enable = true;
    # https://github.com/nushell/nushell/blob/main/crates/nu-utils/src/default_files/doc_config.nu
    extraConfig = ''
      $env.config = {
        show_banner: false,
        completions: {
          algorithm: "fuzzy",
        },
        history: {
          file_format: sqlite,
          isolation: true,
        },
        edit_mode: "vi",
        cursor_shape: {
          vi_insert: "blink_line",
          vi_normal: "blink_block",
        },
        use_kitty_protocol: true,
        bracketed_paste: true,
        keybindings: [
          {
            name: l
            modifier: CONTROL
            keycode: Char_l
            mode: vi_insert
            event:[
                { edit: Clear }
                { edit: InsertString,
                  value: "l"

                }
                { send: Enter }
              ]
          }
          {
            name: clear_screen
            modifier: CONTROL
            keycode: Char_k
            mode: vi_insert
            event:[
                { edit: Clear }
                { edit: InsertString,
                  value: "clear"

                }
                { send: Enter }
              ]
          }
        ]
      };
      $env.DIRENV_LOG_FORMAT = ""
      $env.EDITOR = "nvim"
      $env.IPYTHONDIR = "$env.HOME/.local/share/ipython"
      $env.JUPYTER_CONFIG_DIR = "$env.HOME/.config/jupyter"
      $env.RUSTUP_HOME = "$env.HOME/.local/share/rust"
      $env.CARGO_HOME = "$env.HOME/.local/share/cargo"
      $env.CUDA_CACHE_PATH = "$env.HOME/.cache/nv"
      $env.DOTNET_CLI_HOME = "$env.HOME/.local/share/dotnet"
      $env.DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock"
    '';
  };
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };
  programs.direnv.enableNushellIntegration = true;
  programs.yazi.enableNushellIntegration = true;
  programs.starship.enableNushellIntegration = true;
  programs.zellij.settings.default_shell = "nu";
}
