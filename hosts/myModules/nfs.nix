{
  lib,
  config,
  ...
}: let
  cfg = config.myModules.nfs;

  nfsOpts = [
    "nfsvers=4.2"
    "_netdev"
    "x-systemd.automount"
    "x-systemd.idle-timeout=1min"
    "x-systemd.mount-timeout=30s"
    "nofail"
    "hard" # keep for RW integrity; switch to "soft" only for non-critical RO
    "timeo=600"
    "retrans=2"
  ];

  makeNFS = device: {
    inherit device;
    fsType = "nfs";
    options = nfsOpts;
  };
in {
  options.myModules.nfs = {
    nas = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable /mnt/nas (150.254.111.48:/mnt/Primary/zfn/matmoa).";
    };
    nas2 = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable /mnt/nas2 (150.254.111.3:/mnt/zfn2/zfn2/matmoa).";
    };
  };

  config.fileSystems = lib.mkMerge [
    (lib.mkIf cfg.nas {
      "/mnt/nas" = makeNFS "150.254.111.48:/mnt/Primary/zfn/matmoa";
    })
    (lib.mkIf cfg.nas2 {
      "/mnt/nas2" = makeNFS "150.254.111.3:/mnt/zfn2/zfn2/matmoa";
    })
  ];
}
