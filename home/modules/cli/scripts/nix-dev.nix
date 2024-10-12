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
      args=()
      envargs=()
      for pkg in "$@"; do
        args+=("nixpkgs#$pkg")
        envargs+=("$pkg")
      done
      # Append new packages to NS_PACKAGES, preserving existing ones
      export NS_PACKAGES="''${NS_PACKAGES:+$NS_PACKAGES }''${envargs[*]}"
      NIXPKGS_ALLOW_UNFREE=1 nix shell "''${args[@]}" --impure
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
