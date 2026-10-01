{
  flake.nixosModules.bouedig = {
    config,
    pkgs,
    inputs,
    ...
  }: let
    url = "bouedig.matmoa.eu";
    port = 10003;

    s = config.sops.secrets;
    passwordFile = s."bouedig/password".path;
    openrouterKeyFile = s."bouedig/llm-api-key".path;
  in {
    sops.secrets = {
      "bouedig/password" = {
        owner = "bouedig";
        group = "bouedig";
        mode = "0400";
      };
      "bouedig/llm-api-key" = {
        owner = "bouedig";
        group = "bouedig";
        mode = "0400";
      };
    };
    users.users.mat.extraGroups = ["bouedig"];
    users.users.bouedig.homeMode = "0750";
    services.bouedig = {
      enable = true;
      package = inputs.bouedig.packages.${pkgs.stdenv.hostPlatform.system}.prebuilt;
      bindAddr = "127.0.0.1:${toString port}";

      inherit
        passwordFile
        openrouterKeyFile
        ;
    };

    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
