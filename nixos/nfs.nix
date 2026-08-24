{
  flake.nixosModules.nfs = {...}: let
    makeNFS = device: {
      inherit device;
      fsType = "nfs";

      options = [
        "nfsvers=4.2"
        "_netdev"

        "x-systemd.automount"
        "x-systemd.idle-timeout=1min"

        # NAS being unavailable is not a boot failure.
        "nofail"

        # Fail the initial mount attempt reasonably quickly.
        "x-systemd.mount-timeout=15s"

        # Once successfully mounted, preserve normal hard-NFS
        # semantics rather than risking silent I/O errors.
        "hard"
        "timeo=100"
        "retrans=2"
      ];
    };
  in {
    fileSystems = {
      "/mnt/nas" =
        makeNFS "150.254.111.48:/mnt/Primary/zfn/matmoa";

      "/mnt/nas2" =
        makeNFS "150.254.111.3:/mnt/zfn2/zfn2/matmoa";
    };
  };
}
