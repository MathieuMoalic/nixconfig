{pkgs, ...}: {
  programs.nix-ld = {
    enable = true;
    # here's a neat way to run nearly any binary by including all of the libraries used by Steam:
    # contain most of the needed libs for almost all apps
    libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs;
  };
}
