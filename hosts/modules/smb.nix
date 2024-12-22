{
  config,
  lib,
  pkgs,
  ...
}: let
  defaults = {
    fsType = "cifs";
    defaultOptions = [
      "rw" # Mount as read/write.
      "noserverino" # Avoid inode conflicts with some NAS devices.
      "cache=strict" # Balance caching with data consistency.
      "actimeo=1" # Metadata cache timeout (1s for better performance).
      "file_mode=0660" # Default file permissions (read/write for owner/group).
      "dir_mode=0770" # Default directory permissions (read/write/execute for owner/group).
      "rsize=1048576" # Read buffer size (1 MB for faster reads).
      "wsize=1048576" # Write buffer size (1 MB for faster writes).
      "vers=3.1.1" # Use SMB protocol version 3.1.1 for performance and encryption.
      "gid=100" # Group ID for the mount (users).
    ];
  };
in {
  options.nasMounts = lib.mkOption {
    type = lib.types.attrsOf lib.types.attrs;
    default = {};
    description = "Configuration for NAS mounts (user-defined)";
  };

  config = {
    fileSystems =
      lib.mapAttrs (mountPoint: mount: {
        fsType = defaults.fsType;
        device = mount.deviceAndShare;
        options =
          defaults.defaultOptions
          ++ [
            "credentials=${mount.credentials}"
            "uid=${toString config.users.users.${mount.user}.uid}"
          ];
      })
      config.nasMounts;

    environment.systemPackages = [pkgs.cifs-utils];
  };
}
