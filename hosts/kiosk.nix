{
  config,
  lib,
  pkgs,
  ...
}: {
  # nixos-anywhere --flake <URL to your flake> root@<ip address>
  # nixos-rebuild switch --flake <URL to your flake> --target-host "root@<ip address>"

  services.cage = {
    enable = true;
    program = "${pkgs.chromium}/bin/chromium --incognito --app=https://wanatowka.pl/kiosk --kiosk --no-sandbox --disable-features=Translate";
    user = "root";
    environment = {WLR_LIBINPUT_NO_DEVICES = "1";};
  };

  systemd.services."cage-tty1" = {
    after = [
      "network-online.target"
      "systemd-resolved.service"
    ];
    wants = ["network-online.target"];
  };

  nix = {
    channel.enable = false;
    settings = {
      experimental-features = "nix-command flakes";
    };
  };

  services = {
    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = false;
      };
    };
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPcmHHg1pEOAxvEAyr6p5MY0m3/+BOn8nJOcAf7mMaej"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUUC3kya8Ft2EafiA+4EyivIrOI6X++VkhCig93Yzhq mateusz@Orion"
    ];
  };
  time.timeZone = lib.mkDefault "Europe/Warsaw";
  environment = {
    etc."resolv.conf".text = ''
      nameserver 1.1.1.1'';
  };
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules = [
      "ahci" # SATA controller driver (AHCI protocol)
      "sd_mod" # SCSI disk driver for SATA and USB storage
    ];
    kernelModules = ["kvm-intel"];
  };
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  disko.devices = {
    disk.disk1 = {
      device = lib.mkDefault "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "500M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
  system.stateVersion = "24.11";
}
