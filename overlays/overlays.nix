inputs: self: super: {
  amumax = inputs.amumax.packages.${self.system}.default;
  nvim-unstable = inputs.nixpkgs_unstable.legacyPackages.${self.system}.neovim-unwrapped;
}
