{pkgs, ...}:
pkgs.writeShellApplication {
  name = "j";
  runtimeInputs = with pkgs; [systemd];
  text = ''
    set -e

    if [ -z "$1" ]; then
      echo "Usage: show-invocation-logs <systemd-unit-name>"
      exit 1
    fi

    UNIT="$1"
    INVOCATION_ID=$(systemctl show --value --property=InvocationID "$UNIT")

    if [ -z "$INVOCATION_ID" ]; then
      echo "Failed to get InvocationID for unit: $UNIT"
      exit 1
    fi

    journalctl _SYSTEMD_INVOCATION_ID="$INVOCATION_ID" --no-pager
  '';
}
