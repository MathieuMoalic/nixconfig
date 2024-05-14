{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./base.nix
    ./modules/desktop.nix
  ];

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config.allowUnfree = true;
  };

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    extraOptions = "experimental-features = nix-command flakes";
  };

  services = {
    qemuGuest.enable = true;
    openssh.settings.PermitRootLogin = lib.mkForce "yes";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];
  };

  networking = {
    hostName = "iso";
  };

  # gnome power settings do not turn off screen
  systemd = {
    services.sshd.wantedBy = pkgs.lib.mkForce ["multi-user.target"];
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

  users.extraUsers.root.password = "nixos";

  environment.systemPackages = with pkgs; [
    git
    gum
    (
      writeShellScriptBin "nix_installer"
      ''
        #!/usr/bin/env bash
        set -euo pipefail

        if [ "$(id -u)" -eq 0 ]; then
        	echo "ERROR! $(basename "$0") should be run as a regular user"
        	exit 1
        fi

        if [ ! -d "$HOME/nix/.git" ]; then
        	git clone https://github.com/MathieuMoalic/nixconfig "$HOME/nix"
        fi

        TARGET_HOST=$(gum choose --placeholder="Choose a target host")

        echo "Partitioning Disks"
        sudo nix run github:nix-community/disko \
        --extra-experimental-features "nix-command flakes" \
        --no-write-lock-file \
        -- \
        --mode zap_create_mount \
        "$HOME/dotfiles/hosts/$TARGET_HOST/disks.nix"

        sudo nixos-install --flake "$HOME/nix#$TARGET_HOST"
      ''
    )
  ];
}
