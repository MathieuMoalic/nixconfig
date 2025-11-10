{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.nfs;
  makeNFS = device: {
    inherit device;
    fsType = "nfs";
    options = ["nfsvers=4.2"];
  };
in {
  options.myModules.nfs = {
    enable = lib.mkEnableOption "nfs";
  };

  config = lib.mkIf cfg.enable {
    fileSystems = {
      "/mnt/nas" = makeNFS "150.254.111.48:/mnt/Primary/zfn/matmoa";
      "/mnt/nas2" = makeNFS "150.254.111.3:/mnt/zfn2/zfn2/matmoa";
    };
  };
}
