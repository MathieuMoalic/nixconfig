{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.podman;
in {
  options.myModules.podman = {
    enable = lib.mkEnableOption "podman";
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      oci-containers.backend = "podman";
      containers.enable = true;
      podman.enable = true;
    };
  };
}
