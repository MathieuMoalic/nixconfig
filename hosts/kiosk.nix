{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
  ];
  # nixos-anywhere --flake <URL to your flake> root@<ip address>
  # nixos-rebuild switch --flake <URL to your flake> --target-host "root@<ip address>"

  systemd.services.monitor-on = {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "monitor-on" ''
        echo "on 0" | ${pkgs.libcec}/bin/cec-client -s -d 1
      '';
    };
  };
  systemd.services.monitor-off = {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "monitor-off" ''
        echo "standby 0" | ${pkgs.libcec}/bin/cec-client -s -d 1
      '';
    };
  };
  systemd.timers.monitor-on = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 07:00:00";
      Persistent = true;
      Unit = "monitor-on.service";
    };
  };

  systemd.timers.monitor-off = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 19:00:00";
      Persistent = true;
      Unit = "monitor-off.service";
    };
  };

  systemd.services.restart-cage = {
    description = "Restart the cage service";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl restart cage.service";
    };
  };

  systemd.timers.restart-cage = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 07:00:00";
      Persistent = true;
      Unit = "restart-cage.service";
    };
  };

  services.cage = {
    enable = true;
    program = "${pkgs.firefox}/bin/firefox --private-window https://wanatowka.pl/kiosk --kiosk --no-remote";
    user = "root";
    environment = {WLR_LIBINPUT_NO_DEVICES = "1";};
  };

  # Wait for network and DNS
  systemd.services."cage-tty1" = {
    after = [
      "network-online.target"
      "systemd-resolved.service"
      "firefox-cleanup.service"
    ];
    wants = ["network-online.target" "firefox-cleanup.service"];
  };

  # Service to clean up Firefox files before Cage starts
  systemd.services.firefox-cleanup = {
    serviceConfig = {
      ExecStart = "${pkgs.coreutils}/bin/rm -rf /root/.config/firefox /root/.cache/firefox /root/.mozilla/firefox";
    };
    wantedBy = ["cage-tty1.service"];
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
