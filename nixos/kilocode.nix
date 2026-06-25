{
  flake.nixosModules.kilocode = {
    pkgs,
    config,
    ...
  }: {
    sops.secrets."openrouter/api-key" = {
      owner = "root";
      group = "root";
      mode = "0400";
    };

    environment.systemPackages = with pkgs; [
      kilocode-cli
      litellm
    ];

    sops.templates."kilocode-cli-config.json" = {
      owner = "mat";
      group = "mat";
      mode = "0600";

      content = builtins.toJSON {
        provider = "default";

        providers = [
          {
            id = "default";
            provider = "openai";

            openAiApiKey = config.sops.placeholder."openrouter/api-key";
            openAiBaseUrl = "http://127.0.0.1:4000/v1";
            openAiModelId = "openrouter/z-ai/glm-5.2";
            openAiStreamingEnabled = true;
          }
        ];

        mcp = {
          enabled = true;
        };

        mode = "code";
      };
    };

    systemd.tmpfiles.rules = [
      "d /home/mat/.kilocode 0700 mat mat - -"
      "d /home/mat/.kilocode/cli 0700 mat mat - -"
      "L+ /home/mat/.kilocode/cli/config.json - - - - ${config.sops.templates."kilocode-cli-config.json".path}"
    ];
  };
}
