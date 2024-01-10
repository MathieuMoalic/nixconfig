{...}: {
  home.sessionVariables = {
    # EDITOR = "${pkgs.helix}/bin/hx"; # already set in helix.nix
    VISUAL = "$EDITOR";
    SUDO_EDIT = "$EDITOR";
    GNUPGHOME = "$HOME/.local/share/gnupg";
    JUPYTER_CONFIG_DIR = "$HOME/.config/jupyter";
    # LESSHISTFILE = "$XDG_CACHE_HOME/less/history";
    # _Z_DATA = "$XDG_DATA_HOME/z";
    # ZSH_COMPDUMP = "$ZSH/cache/.zcompdump-$HOST";
    # RUSTUP_HOME = "$XDG_DATA_HOME/rust";
    # CARGO_HOME = "$XDG_DATA_HOME/cargo";
    CUDA_CACHE_PATH = "$HOME/.cache/nv";
    # GOPATH = "$XDG_DATA_HOME/go";
  };
}
