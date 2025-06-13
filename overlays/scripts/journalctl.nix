{pkgs, ...}:
pkgs.writeShellApplication {
  name = "j";
  runtimeInputs = with pkgs; [systemd coreutils];
  text = ''
    #!/usr/bin/env bash
    set -euo pipefail

    usage() {
      echo "Usage: j <systemd-unit-name> [--follow]"
      echo
      echo "Show logs for the current invocation of a systemd unit."
      echo
      echo "Options:"
      echo "  --follow     Follow logs (like tail -f)"
      echo "  -h, --help   Show this help message"
    }

    if [ $# -eq 0 ]; then
      usage
      exit 1
    fi

    case "$1" in
      -h|--help)
        usage
        exit 0
        ;;
    esac

    UNIT="$1"
    shift

    # Optional journalctl arguments (e.g. --follow)
    JOURNAL_ARGS=("$@")

    if ! systemctl show "$UNIT" >/dev/null 2>&1; then
      echo "Error: Unit '$UNIT' does not exist or is not loaded." >&2
      exit 1
    fi

    INVOCATION_ID=$(systemctl show --value --property=InvocationID "$UNIT")

    if [ -z "$INVOCATION_ID" ]; then
      echo "Failed to get InvocationID for unit: $UNIT" >&2
      exit 1
    fi

    exec journalctl _SYSTEMD_INVOCATION_ID="$INVOCATION_ID" --no-pager -o cat "''${JOURNAL_ARGS[@]}"
  '';
}
