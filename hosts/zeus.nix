{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.zeus = self.lib.mkHost {
    hostName = "zeus";
    system = "x86_64-linux";
    stateVersion = "23.11";

    nixosModules = with self.nixosModules; [
      sshd
      ollama
    ];

    userModules = with self.nixosModules; [
      mat
      kelvas
      mz
    ];

    hostConfig = {
      config,
      lib,
      pkgs,
      ...
    }: {
      environment.systemPackages = let
        system = pkgs.stdenv.hostPlatform.system;

        amumax-fixed = inputs.amumax.packages.${system}.git.overrideAttrs (old: {
          nativeBuildInputs =
            (old.nativeBuildInputs or [])
            ++ [
              pkgs.patchelf
            ];

          postFixup =
            (old.postFixup or "")
            + ''
              bin="$out/bin/amumax"

              old_rpath="$(patchelf --print-rpath "$bin")"

              new_rpath="$(
                echo "$old_rpath" \
                  | tr ':' '\n' \
                  | grep -v -- '-glibc-' \
                  | paste -sd: -
              )"

              new_rpath="$new_rpath:${pkgs.glibc}/lib"

              patchelf \
                --set-interpreter ${pkgs.stdenv.cc.bintools.dynamicLinker} \
                --set-rpath "$new_rpath" \
                "$bin"
            '';
        });
      in [
        amumax-fixed
        pkgs.nvtopPackages.nvidia
      ];
      hardware = {
        nvidia-container-toolkit.enable = true;
        graphics.enable = true;
        nvidia = {
          modesetting.enable = true;
          powerManagement = {
            enable = true;
            finegrained = false;
          };
          open = false;
          nvidiaSettings = true;
          package = config.boot.kernelPackages.nvidiaPackages.stable;
        };
        cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
      boot = {
        kernel.sysctl = {
          "net.ipv4.ip_unprivileged_port_start" = "80";
        };
        initrd = {
          availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
          kernelModules = [];
        };
        kernelModules = ["kvm-intel"];
        extraModulePackages = [];
      };
      fileSystems = {
        "/" = {
          device = "/dev/disk/by-uuid/39595a30-eacd-4724-ba4a-ffd9faf23ba3";
          fsType = "ext4";
        };
        "/boot" = {
          device = "/dev/disk/by-uuid/339D-CFC9";
          fsType = "vfat";
        };
      };
      swapDevices = [
        {
          device = "/swapfile";
          size = 16 * 1024;
        }
      ];
      networking = {
        firewall = {
          enable = true;
          allowedTCPPorts = [80 443 8080];
        };
      };
      services.xserver.videoDrivers = ["nvidia"];
    };
  };
}
