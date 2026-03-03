{inputs, ...}: let
  overlay = final: prev: let
    unstable = import inputs.nixpkgs_unstable {
      inherit (final.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
  in {
    cop = final.writeShellApplication {
      name = "cop";
      runtimeInputs = [unstable.github-copilot-cli final.coreutils];
      text = ''
        mkdir -p ~/.local/copilot-shims
        ln -sf ${final.bash}/bin/bash ~/.local/copilot-shims/bash
        export PATH="$HOME/.local/copilot-shims:$PATH"
        export SHELL=${final.bash}/bin/bash
        export CONFIG_SHELL=${final.bash}/bin/bash
        exec copilot --allow-all
      '';
    };
  };
in {
  flake.overlays.cop = overlay;
}
