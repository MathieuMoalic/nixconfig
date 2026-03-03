{
  flake.homeModules.nixSettings = {...}: {
    nix.settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      use-xdg-base-directories = true;
      warn-dirty = false;
    };
  };
}
