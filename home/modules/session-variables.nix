{...}: {
  home.sessionVariables = {
    VISUAL = "$EDITOR";
    SUDO_EDIT = "$EDITOR";
    NIXOS_OZONE_WL = "1";

    # Cleaning my home directory
    # I think this doesn't work because of uwsm, or maybe
    # because of nushell, a copy of this is in nu.nix
    IPYTHONDIR = "$HOME/.local/share/ipython";
    JUPYTER_CONFIG_DIR = "$HOME/.config/jupyter";
    RUSTUP_HOME = "$HOME/.local/share/rust";
    CARGO_HOME = "$HOME/.local/share/cargo";
    CUDA_CACHE_PATH = "$HOME/.cache/nv";
    DOTNET_CLI_HOME = "$HOME/.local/share/dotnet";
    DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock";
  };
}
