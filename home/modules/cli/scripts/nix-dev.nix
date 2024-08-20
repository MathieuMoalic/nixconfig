{
  pkgs,
  osConfig,
  ...
}: let
  script1 = pkgs.writeShellApplication {
    name = "nr";
    text = ''
      NIXPKGS_ALLOW_UNFREE=1 nix run nixpkgs#"$1" --impure
    '';
  };
  script2 = pkgs.writeShellApplication {
    name = "ns";
    text = ''
      NIXPKGS_ALLOW_UNFREE=1 nix shell nixpkgs#"$1" --impure
    '';
  };
  script3 = pkgs.writeShellApplication {
    name = "nx";
    text = ''
      NIXOS_CONFIG=/home/mat/nix#${osConfig.networking.hostName} nix run github:water-sucks/nixos/0.11.0 -- option -i
    '';
  };
in {
  home.packages = [
    script1
    script2
    script3
  ];
}
