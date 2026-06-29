{
  flake.nixosModules.kilocode = {
    pkgs,
    config,
    inputs,
    ...
  }: let
    system = pkgs.stdenv.hostPlatform.system;
    kilocode-cli = inputs.llm-agents.packages.${system}.kilocode-cli;
  in {
    sops.secrets."openrouter/api-key" = {
      owner = "root";
      group = "root";
      mode = "0400";
    };

    users.groups.litellm = {};
    users.users.litellm = {
      isSystemUser = true;
      group = "litellm";
    };

    environment.systemPackages = [
      kilocode-cli
      pkgs.litellm
    ];

    sops.templates."litellm-config.yaml" = {
      owner = "litellm";
      group = "litellm";
      mode = "0400";

      content = ''
        model_list:
          - model_name: openrouter/z-ai/glm-5.2
            litellm_params:
              model: openrouter/z-ai/glm-5.2
              api_key: ${config.sops.placeholder."openrouter/api-key"}
      '';
    };

    systemd.services.litellm = {
      description = "LiteLLM OpenAI-compatible proxy";
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      after = [
        "network-online.target"
        "sops-nix.service"
      ];

      serviceConfig = {
        User = "litellm";
        Group = "litellm";
        Restart = "on-failure";
        RestartSec = "5s";

        ExecStart = ''
          ${pkgs.litellm}/bin/litellm \
            --host 127.0.0.1 \
            --port 4000 \
            --config ${config.sops.templates."litellm-config.yaml".path}
        '';
      };
    };

    sops.templates."kilo.jsonc" = {
      owner = "mat";
      group = "mat";
      mode = "0600";

      content = builtins.toJSON {
        "$schema" = "https://app.kilo.ai/config.json";

        model = "openai-compatible/openrouter/z-ai/glm-5.2";

        provider = {
          "openai-compatible" = {
            options = {
              # This is the key Kilo sends to the LiteLLM proxy.
              # If you later set a LiteLLM master key, use that here instead.
              apiKey = config.sops.placeholder."openrouter/api-key";
              baseURL = "http://127.0.0.1:4000/v1";
            };

            models = {
              "openrouter/z-ai/glm-5.2" = {
                name = "OpenRouter Z.ai GLM-5.2 via LiteLLM";
                id = "openrouter/z-ai/glm-5.2";
                tool_call = true;
                temperature = true;
              };
            };
          };
        };

        # This is only for MCP tool servers.
        # LiteLLM does not belong here unless you intentionally use
        # LiteLLM's MCP Gateway feature.
        mcp = {};
      };
    };

    systemd.tmpfiles.rules = [
      "d /home/mat/.config 0700 mat mat - -"
      "d /home/mat/.config/kilo 0700 mat mat - -"
      "L+ /home/mat/.config/kilo/kilo.jsonc - - - - ${config.sops.templates."kilo.jsonc".path}"
    ];
  };
}
