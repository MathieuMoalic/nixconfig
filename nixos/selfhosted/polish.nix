{
  flake.nixosModules.polish = {pkgs, ...}: let
    site = pkgs.writeTextDir "index.html" (
      builtins.readFile ./polish.html
    );
  in {
    services.caddy.virtualHosts."polish.matmoa.eu".extraConfig = ''
      handle /translate {
        reverse_proxy 127.0.0.1:10027
      }

      handle {
        root * ${site}
        encode zstd gzip
        file_server
      }
    '';
  };
}
