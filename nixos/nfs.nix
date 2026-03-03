{...}: {
  flake.nixosModules.nfs = {...}: let
    makeNFS = device: {
      inherit device;
      fsType = "nfs";
      options = [
        "nfsvers=4.2"
        "_netdev"
        "x-systemd.automount"
        "x-systemd.idle-timeout=1min"
        "x-systemd.mount-timeout=30s"
        "nofail"
        "hard"
        "timeo=600"
        "retrans=2"
      ];
    };
  in {
    fileSystems = {
      "/mnt/nas" = makeNFS "150.254.111.48:/mnt/Primary/zfn/matmoa";
      "/mnt/nas2" = makeNFS "150.254.111.3:/mnt/zfn2/zfn2/matmoa";
      "/home/mat/projects/radial_vortex/nas" =
        makeNFS "150.254.111.3:/mnt/zfn2/zfn2/matmoa/jobs/radial_vortex";
      "/home/mat/projects/preludium/nas" =
        makeNFS "150.254.111.3:/mnt/zfn2/zfn2/matmoa/jobs/preludium";
    };
  };
}
