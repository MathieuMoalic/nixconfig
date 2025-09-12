{...}: let
  nfsV42 = device: {
    inherit device;
    fsType = "nfs";
    options = ["nfsvers=4.2"];
  };
in {
  fileSystems = {
    "/home/mat/nas" = nfsV42 "150.254.111.48:/mnt/Primary/zfn/matmoa";
    "/home/mat/nas2" = nfsV42 "150.254.111.3:/mnt/zfn2/zfn2/matmoa";
    "/home/mat/projects/double_freq_gen/nas" = nfsV42 "150.254.111.3:/mnt/zfn2/zfn2/matmoa/jobs/double_freq_gen";
    "/home/mat/projects/preludium/nas" = nfsV42 "150.254.111.3:/mnt/zfn2/zfn2/matmoa/jobs/preludium";
    "/home/mat/projects/mannga/nas" = nfsV42 "150.254.111.3:/mnt/zfn2/zfn2/matmoa/jobs/mannga";
  };
}
