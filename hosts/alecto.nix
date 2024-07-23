{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ./base.nix
    ./modules/desktop.nix
    ./modules/sddm.nix
    ./modules/syncthing.nix
    ./modules/samba.nix
  ];
  home-manager.users.mat.imports = [../home/alecto.nix];

  wsl = {
    enable = true;
    extraBin = with pkgs; [
      {src = "${coreutils}/bin/uname";}
    ];
    defaultUser = "mat";
  };

  programs.mosh = {
    enable = true;
    openFirewall = true;
    withUtempter = true;
  };

  hardware = {
    nvidia-container-toolkit.enable = true;
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true; # Needed for Hyprland
      powerManagement = {
        enable = true;
        finegrained = false;
      };
      nvidiaSettings = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  virtualisation = {
    containers.enable = true;
    podman.enable = true;
  };

  networking = {
    hostName = "alecto";
    firewall = {
      enable = false;
    };
    useDHCP = lib.mkDefault true;
  };

  services = {
    openssh = {
      enable = true;
      ports = [46464];
      openFirewall = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
      };
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "24.05";
}
