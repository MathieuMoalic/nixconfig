{
  flake.nixosModules.auto-update = {pkgs, ...}: let
    repo = "/home/mat/nix";
    ntfyUrl = "https://ntfy.matmoa.eu/auto-update";
  in {
    systemd.services.auto-update-nixpkgs = {
      description = "Update nixpkgs flake input, build system, commit, push, notify, and reboot";

      wants = ["network-online.target"];
      after = ["network-online.target"];

      path = with pkgs; [
        nix
        nh
        git
        openssh
        curl
        sudo
        systemd
        coreutils
        hostname
      ];

      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = repo;

        # Avoid overlapping/hung runs.
        TimeoutStartSec = "2h";
      };

      script = ''
        set -euo pipefail

        notify() {
          curl -fsS -d "$1" ${ntfyUrl} >/dev/null || true
        }

        run_as_mat() {
          sudo -u mat -H env PATH="$PATH" bash -c "$1"
        }

        trap 'status=$?; notify "❌ auto-update-nixpkgs failed on $(hostname) at line $LINENO with exit code $status. Check: journalctl -u auto-update-nixpkgs.service -n 100 --no-pager"; exit $status' ERR

        echo "Updating nixpkgs flake input..."
        run_as_mat "cd ${repo} && nix flake update nixpkgs"

        echo "Building system..."
        run_as_mat "cd ${repo} && nh os switch -v ${repo}"

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

        notify "✅ auto-update-nixpkgs succeeded on $(hostname): nixpkgs updated, build passed, committed, and pushed. Rebooting now."

        echo "Rebooting..."
        sleep 5
        systemctl reboot
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
