{inputs, ...}: {
  flake.overlays.default = final: prev:
    (import ../overlays/overlays.nix inputs) final prev;
}
