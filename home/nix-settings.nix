{
  flake.homeModules.nixSettings = {...}: {
    nix.settings = {
      experimental-features = "nix-command flakes";
      warn-dirty = false;
      substituters = [
        "https://cache.nixos.org"
        "https://cache.nixos-cuda.org"
      ];
    };
  };
}
