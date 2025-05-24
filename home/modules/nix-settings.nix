{...}: {
  # in ~/.config/nix/nix.conf
  nix.settings = {
    # for home manager
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
    use-xdg-base-directories = true;
    warn-dirty = false;
  };
}
