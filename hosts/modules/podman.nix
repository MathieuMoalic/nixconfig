{...}: {
  virtualisation = {
    oci-containers.backend = "podman";
    containers.enable = true;
    podman.enable = true;
  };
}
