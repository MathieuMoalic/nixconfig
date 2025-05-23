inputs: self: super: {
  amumax = inputs.amumax.packages.${self.system}.default;
  nvim-unstable = inputs.nixpkgs_unstable.legacyPackages.${self.system}.neovim-unwrapped;
  quicktranslate = inputs.quicktranslate.packages.${self.system}.quicktranslate;
  rose-pine-hyprcursor = inputs.rose-pine-hyprcursor.packages.${self.system}.default;
  lock = super.callPackage ./scripts/lock.nix {};
  decode = super.callPackage ./scripts/decode.nix {};
  encode = super.callPackage ./scripts/encode.nix {};
  lnmv = super.callPackage ./scripts/lnmv.nix {};
  nix-run = super.callPackage ./scripts/nix-run.nix {};
  nix-shell = super.callPackage ./scripts/nix-shell.nix {};
  power-menu = super.callPackage ./scripts/power-menu.nix {};
  screenshot-edit = super.callPackage ./scripts/screenshot-edit.nix {};
  screenshot = super.callPackage ./scripts/screenshot.nix {};
  update = super.callPackage ./scripts/update.nix {};
  wireguard-menu = super.callPackage ./scripts/wireguard-menu.nix {};
}
