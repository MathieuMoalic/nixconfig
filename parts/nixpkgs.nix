{
  lib,
  inputs,
  config,
  ...
}: {
  options.my.mkPkgs = lib.mkOption {
    type = lib.types.raw;
    readOnly = true;
    description = "mkPkgs system -> pkgs (nixpkgs pinned + overlays + allowUnfree).";
  };

  config.my.mkPkgs = system:
    import inputs.nixpkgs {
      inherit system;
      overlays = config.my.overlays;
      config.allowUnfree = true;
    };
}
