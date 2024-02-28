{...}: {
  imports = [
    ./hardware-configuration.nix
    ../base.nix
    ../modules/sddm
    ../modules/syncthing.nix
  ];

  virtualisation = {
    # containers.cdi.nvidia = "nvidia-ctk-generate";
    libvirtd.enable = true;
    podman = {
      enable = true;
    };
  };
  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = "80";
  };

  networking.hostName = "homeserver";
  networking.firewall = {
    enable = true;
    # 8096 is jellyfin
    allowedTCPPorts = [80 443 8096];
  };
  services.openssh = {
    enable = true;
    ports = [46464]; # Set SSH to listen on port 46464
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
  system.stateVersion = "23.11";
}
