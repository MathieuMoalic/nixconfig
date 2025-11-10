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
  };
}
