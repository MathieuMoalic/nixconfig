{
  flake.nixosModules.polish = {
    inputs,
    pkgs,
    ...
  }: {
    services.caddy.virtualHosts."polish.matmoa.eu".extraConfig = ''
      handle /translate {
        reverse_proxy 127.0.0.1:10027
      }

      handle {
        root * ${inputs.polish.packages.${pkgs.system}.default}
        encode zstd gzip
        file_server
      }
    '';
  };
}
