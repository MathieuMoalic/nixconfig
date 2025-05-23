{pkgs, ...}:
pkgs.writeShellApplication {
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
}
