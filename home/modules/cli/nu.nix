{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index # weekly nix-index refresh
  ];
  programs = {
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    nushell = {
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
        $env.DIRENV_LOG_FORMAT = "";
        $env.EDITOR = "nvim";
        $env.IPYTHONDIR = "${config.home.homeDirectory}/.local/share/ipython";
        $env.JUPYTER_CONFIG_DIR = "${config.home.homeDirectory}/.config/jupyter";
        $env.RUSTUP_HOME = "${config.home.homeDirectory}/.local/share/rust";
        $env.CARGO_HOME = "${config.home.homeDirectory}/.local/share/cargo";
        $env.CUDA_CACHE_PATH = "${config.home.homeDirectory}/.cache/nv";
        $env.DOTNET_CLI_HOME = "${config.home.homeDirectory}/.local/share/dotnet";
        $env.DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock";
      '';
    };
    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
    direnv.enableNushellIntegration = true;
    yazi.enableNushellIntegration = true;
    starship.enableNushellIntegration = true;
    zellij.settings.default_shell = "nu";
  };
}
