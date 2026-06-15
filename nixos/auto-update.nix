{
  flake.nixosModules.auto-update = {pkgs, ...}: let
    repo = "/home/mat/nix";
    host = "homeserver";
    flakeRef = "path:${repo}#${host}";
    ntfyUrl = "https://ntfy.matmoa.eu/auto-update";
  in {
    systemd.services.auto-update-nixpkgs = {
      description = "Update nixpkgs flake input, build system, commit, push, notify, and reboot";

      wants = ["network-online.target"];
      after = ["network-online.target"];

      # Important: this service may change during a rebuild.
      # Do not let nixos-rebuild switch/activation kill or restart the updater
      # while it is the process performing the update.
      restartIfChanged = false;
      stopIfChanged = false;

      path = with pkgs; [
        bash
        nix
        nixos-rebuild
        git
        openssh
        curl
        sudo
        systemd
        coreutils
        hostname
        util-linux
      ];

      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = repo;

        # Avoid hung runs.
        TimeoutStartSec = "2h";
      };

      script = ''
        set -euo pipefail

        notify() {
          curl -fsS -d "$1" ${ntfyUrl} >/dev/null || true
        }

        run_as_mat() {
          ${pkgs.sudo}/bin/sudo -u mat -H env \
            HOME=/home/mat \
            PATH="$PATH" \
            ${pkgs.bash}/bin/bash -c "$1"
        }

        trap 'status=$?; notify "❌ auto-update-nixpkgs failed on $(hostname) at line $LINENO with exit code $status. Check: journalctl -u auto-update-nixpkgs.service -n 100 --no-pager"; exit $status' ERR

        {
          flock -n 9 || {
            echo "Another auto-update-nixpkgs run is already active."
            notify "⚠️ auto-update-nixpkgs skipped on $(hostname): another run is already active."
            exit 0
          }

          echo "Updating nixpkgs flake input..."
          run_as_mat "cd ${repo} && nix flake update nixpkgs"

          echo "Building system and setting it as next boot..."
          cd ${repo}

          # Use boot, not switch:
          # - this service reboots after success anyway
          # - switch can restart/kill this service during live activation
          # - boot prepares the next generation without mutating the running system
          nixos-rebuild boot --flake '${flakeRef}'

          echo "Checking git changes..."
          run_as_mat "cd ${repo} && git add -A ."

          if run_as_mat "cd ${repo} && git diff --cached --quiet"; then
            echo "No changes to commit."
            notify "✅ auto-update-nixpkgs succeeded on $(hostname): nixpkgs checked, build passed, no git changes. No reboot needed."
            exit 0
          fi

          echo "Committing changes..."
          run_as_mat "cd ${repo} && git commit -m 'update nixpkgs'"

          echo "Pushing changes..."
          run_as_mat "cd ${repo} && git push"

          notify "✅ auto-update-nixpkgs succeeded on $(hostname): nixpkgs updated, build passed, committed, pushed, and prepared for next boot. Rebooting now."

          echo "Rebooting..."
          sleep 5
          systemctl reboot
        } 9>/run/auto-update-nixpkgs.lock
      '';
    };

    systemd.timers.auto-update-nixpkgs = {
      description = "Run nixpkgs auto-update every Monday at 04:00";

      wantedBy = ["timers.target"];

      timerConfig = {
        OnCalendar = "Mon 04:00";
        Persistent = true;
        RandomizedDelaySec = "15m";
        Unit = "auto-update-nixpkgs.service";
      };
    };
  };
}
