{pkgs, ...}: {
  nix.package = pkgs.nix;
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
    use-xdg-base-directories = true;
    warn-dirty = false;
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };
  # needed for nix-shell
  xdg.configFile."nixpkgs/config.nix".text = ''{allowUnfree = true;}'';
}
