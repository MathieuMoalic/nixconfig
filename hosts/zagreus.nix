{self, ...}: {
  flake.nixosConfigurations.zagreus = self.lib.mkHost {
    hostName = "zagreus";
    system = "x86_64-linux";
    stateVersion = "24.05";

    nixosModules = with self.nixosModules; [
      desktop
      sshd
      nfs
    ];

    userModules = with self.nixosModules; [
      mat
      mat-desktop
    ];

    hostConfig = {
      config,
      lib,
      pkgs,
      ...
    }: {
      virtualisation.spiceUSBRedirection.enable = true;
      programs.adb.enable = true;
      users.groups.adbusers = {};
      users.users.mat.extraGroups = ["adbusers"];
      programs.steam.enable = true;

      hardware = {
        cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        wooting.enable = true;
      };

      networking = {
        firewall = {
          enable = true;
        };
      };

      boot = {
        initrd = {
          availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
          systemd.enable = true;
        };
        extraModprobeConfig = ''
          options iwlwifi power_save=0 uapsd_disable=1 enable_ini=0
          options iwlmvm power_scheme=1
        '';
        kernelParams = ["pcie_aspm=off"];
      };

      environment.etc."NetworkManager/conf.d/99-wifi-powersave.conf".text = ''
        [connection]
        wifi.powersave=2
      '';

      services = {
        udev.extraRules = ''
          ACTION=="add" SUBSYSTEM=="pci" ATTR{vendor}=="0x1987" ATTR{device}=="0x5013" ATTR{power/wakeup}="disabled"
          ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="31e3", ATTR{idProduct}=="1312", ATTR{power/wakeup}="disabled"
          ACTION=="add|bind", SUBSYSTEM=="usb", TEST=="power/wakeup", ATTR{power/wakeup}="disabled"
          # Disable nvme drive from instantly waking up after suspend
          ACTION=="add", SUBSYSTEM=="pci", KERNELS=="0000:00:01.1", ATTR{power/wakeup}="disabled"
          # OPPO / OnePlus (vendor 22d9) — allow ADB access for adbusers
          SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="22d9", MODE="0660", GROUP="adbusers"
        '';
      };

      systemd.services.disable-usb-acpi-wake = {
        description = "Disable ACPI wake for USB host controllers";
        wantedBy = ["multi-user.target"];
        after = ["local-fs.target"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "disable-usb-acpi-wake" ''
            set -eu
            if [ -e /proc/acpi/wakeup ]; then
              awk '$0 ~ /(XHC|EHC|USB)/ && $0 ~ /\*enabled/ {print $1}' /proc/acpi/wakeup | \
              while read -r dev; do
                echo "$dev" > /proc/acpi/wakeup
              done
            fi
          '';
        };
      };

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-label/NIXROOT";
          fsType = "ext4";
        };
        "/boot" = {
          device = "/dev/disk/by-label/NIXBOOT";
          fsType = "vfat";
        };
      };

      swapDevices = [
        {
          device = "/var/lib/swapfile";
          size = 32 * 1024;
        }
      ];
    };
  };
}
