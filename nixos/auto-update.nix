{
  flake.nixosModules.auto-update = {pkgs, ...}: let
    repo = "/home/mat/nix";
    ntfyUrl = "https://ntfy.matmoa.eu/auto-update";
  in {
    systemd.services.auto-update-nixpkgs = {
      description = "Update nixpkgs flake input, build system, commit, push, and notify";

      wants = ["network-online.target"];
      after = ["network-online.target"];

      path = with pkgs; [
        nix
        nh
        git
        openssh
        curl
        hostname
      ];

      environment = {
        HOME = "/home/mat";
      };

      serviceConfig = {
        Type = "oneshot";
        User = "mat";
        Group = "mat";
        WorkingDirectory = repo;

        # Avoid overlapping/hung runs.
        TimeoutStartSec = "2h";
      };

      script = ''
        set -euo pipefail

        notify() {
          curl -fsS -d "$1" ${ntfyUrl} >/dev/null || true
        }

        trap 'status=$?; notify "❌ auto-update-nixpkgs failed on $(hostname) at line $LINENO with exit code $status. Check: journalctl -u auto-update-nixpkgs.service -n 100 --no-pager"; exit $status' ERR

        cd ${repo}

        echo "Updating nixpkgs flake input..."
        nix flake update nixpkgs

        echo "Building system..."
        nh os build -v ${repo}

        echo "Checking git changes..."
        git add -A .

        if git diff --cached --quiet; then
          echo "No changes to commit."
          notify "✅ auto-update-nixpkgs succeeded on $(hostname): nixpkgs checked, build passed, no git changes."
          exit 0
        fi

        echo "Committing changes..."
        git commit -m "update nixpkgs"

        echo "Pushing changes..."
        git push

        notify "✅ auto-update-nixpkgs succeeded on $(hostname): nixpkgs updated, build passed, committed, and pushed."
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
