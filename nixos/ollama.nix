{
  flake.nixosModules.ollama = {
    config,
    pkgs,
    ...
  }: let
    chatDomain = "chat.matmoa.eu";
    llmDomain = "llm.matmoa.eu";
  in {
    sops = {
      secrets."ollama/llm_api_token" = {
        owner = "caddy";
        group = "caddy";
        mode = "0400";
      };
      templates."caddy-llm.env" = {
        owner = "caddy";
        group = "caddy";
        mode = "0400";
        content = ''
          LLM_API_TOKEN=${config.sops.placeholder."ollama/llm_api_token"}
        '';
      };
    };

    networking.firewall.allowedTCPPorts = [80 443];
    services.ollama = {
      enable = true;
      package = pkgs.ollama-cuda;

      host = "127.0.0.1";
      port = 11434;

      environmentVariables = {
        CUDA_VISIBLE_DEVICES = "0,1,2,3,4,5,6";
        OLLAMA_MODELS = "/var/lib/ollama/models";

        OLLAMA_CONTEXT_LENGTH = "65536";
        OLLAMA_NUM_PARALLEL = "1";
        OLLAMA_MAX_LOADED_MODELS = "1";

        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_KV_CACHE_TYPE = "q8_0";
      };
    };

    services.open-webui = {
      enable = true;

      host = "127.0.0.1";
      port = 8080;

      environment = {
        OLLAMA_BASE_URL = "http://127.0.0.1:11434";
        WEBUI_URL = "https://${chatDomain}";
        CORS_ALLOW_ORIGIN = "https://${chatDomain}";
        DATA_DIR = "/var/lib/open-webui";
      };
    };

    services.caddy = {
      enable = true;
      environmentFile = config.sops.templates."caddy-llm.env".path;
      virtualHosts.${chatDomain}.extraConfig = ''
        reverse_proxy 127.0.0.1:8080
      '';

      virtualHosts.${llmDomain}.extraConfig = ''
        @authorized header Authorization "Bearer {$LLM_API_TOKEN}"

        handle @authorized {
          reverse_proxy 127.0.0.1:11434 {
            header_up Host 127.0.0.1:11434

            transport http {
              read_timeout 1800s
            }
          }
        }

        handle {
          respond "Unauthorized" 401
        }
      '';
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/ollama/models 0755 ollama ollama -"
      "d /var/lib/open-webui 0755 open-webui open-webui -"
    ];
  };
}
