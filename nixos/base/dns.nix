{
  flake.nixosModules.dns = {
    services.resolved.enable = true;

    networking.networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
  };
}
