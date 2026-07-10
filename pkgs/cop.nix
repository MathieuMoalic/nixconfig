{...}: {
  flake.overlays.cop = final: prev: let
    version = "1.0.70";

    github-copilot-cli = prev.github-copilot-cli.overrideAttrs (old: {
      inherit version;

      src = final.fetchurl {
        url = "https://github.com/github/copilot-cli/releases/download/v${version}/github-copilot-${version}-linux-x64.tgz";
        hash = "sha256-z70Rb+FZviiaut8sK/GKJairCe7KVKCR1AJeHLzaRwk=";
      };

      meta =
        old.meta
        // {
          changelog = "https://github.com/github/copilot-cli/releases/tag/v${version}";
          platforms = ["x86_64-linux"];
        };
    });
  in {
    inherit github-copilot-cli;

    cop = final.writeShellApplication {
      name = "cop";

      runtimeInputs = [
        github-copilot-cli
        final.coreutils
        final.bash
      ];

      text = ''
        mkdir -p "$HOME/.local/copilot-shims"
        ln -sf ${final.bash}/bin/bash "$HOME/.local/copilot-shims/bash"

        export PATH="$HOME/.local/copilot-shims:$PATH"
        export SHELL=${final.bash}/bin/bash
        export CONFIG_SHELL=${final.bash}/bin/bash

        exec copilot --allow-all "$@"
      '';
    };
  };
}
