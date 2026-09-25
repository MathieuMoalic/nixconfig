{
  flake.nixosModules.polish = {pkgs, ...}: let
    site = pkgs.fetchFromGitHub {
      owner = "MathieuMoalic";
      repo = "polish";
      rev = "b76d0fbf9a24a628a94c62fbc0a255a4c1f5d1bc";
      hash = "sha256-oda7ROBBOfMCeZFNWMbG6+BsTP6KnkFdw1dMq5/WDN0=";
    };
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
