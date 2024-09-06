{...}: {
  home.sessionVariables = {
    VISUAL = "$EDITOR";
    SUDO_EDIT = "$EDITOR";
    NIXOS_OZONE_WL = "1";

    # Cleaning my home directory
    IPYTHONDIR = "$HOME/.local/share/ipython";
    JUPYTER_CONFIG_DIR = "$HOME/.config/jupyter";
    RUSTUP_HOME = "$HOME/.local/share/rust";
    CARGO_HOME = "$HOME/.local/share/cargo";
    CUDA_CACHE_PATH = "$HOME/.cache/nv";
    DOTNET_CLI_HOME = "$HOME/.local/share/dotnet";
  };
}
