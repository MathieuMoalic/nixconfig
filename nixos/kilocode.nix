{
  flake.nixosModules.kilocode = {
    pkgs,
    config,
    inputs,
    ...
  }: let
    system = pkgs.stdenv.hostPlatform.system;
    kilocode-cli = inputs.llm-agents.packages.${system}.kilocode-cli;

    ollamaModel = "qwen3-coder:30b";
  in {
    sops.secrets."openrouter/api-key" = {
      owner = "root";
      group = "root";
      mode = "0400";
    };

    sops.secrets."ollama/llm_api_token" = {
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

        model = "openrouter/z-ai/glm-5.2";

        provider = {
          openrouter = {
            options = {
              apiKey = config.sops.placeholder."openrouter/api-key";
            };
          };
          ollama-remote = {
            name = "selfhosted";
            npm = "@ai-sdk/openai-compatible";
            options = {
              apiKey = config.sops.placeholder."ollama/llm_api_token";
              baseURL = "https://llm.matmoa.eu/v1";
              timeout = 1800000;
              headerTimeout = false;
            };

            models = {
              "${ollamaModel}" = {
                name = "${ollamaModel}";
                id = ollamaModel;
                tool_call = true;
                temperature = true;
                limit = {
                  context = 65536;
                  output = 8192;
                };
              };
            };
          };
        };

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
