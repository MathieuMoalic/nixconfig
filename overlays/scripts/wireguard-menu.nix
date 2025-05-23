{pkgs, ...}:
pkgs.writeShellApplication {
  name = "wireguard-menu";
  runtimeInputs = with pkgs; [networkmanager busybox rofi-wayland];
  text = ''
    set +o pipefail
    ACTIVE_PREFIX="  ✓ "
    INACTIVE_PREFIX="  ✗ "

    list_wireguard_connections() {
        nmcli --get-values ACTIVE,NAME,TYPE connection show \
            | grep ':wireguard$' \
            | sed \
                -e "s/^no:/$INACTIVE_PREFIX/" \
                -e "s/^yes:/$ACTIVE_PREFIX/" \
                -e 's/:wireguard$//'
    }

    extract_connection_name_from_result() {
        result="$1"

        # Remove the ACTIVE or INACTIVE prefix using sed
        connection=''${result#"$ACTIVE_PREFIX"}
        connection=''${connection#"$INACTIVE_PREFIX"}
        # Trim leading and trailing whitespace
        echo "$connection" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
    }

    toggle_wireguard_connection() {
        result="$1"
        connection=""

        # Extract the connection name, removing prefixes
        connection=$(extract_connection_name_from_result "$result")
        echo "Toggling connection: $connection"

        # List all active WireGuard connections and bring them down
        active_connections=$(nmcli --get-values NAME,TYPE connection show --active \
          | grep ':wireguard$' \
          | cut -d: -f1)

        for active_connection in $active_connections; do
            if [ "$active_connection" != "$connection" ]; then
                echo "Bringing down active connection: $active_connection"
                nmcli connection down "$active_connection"
            fi
        done

        # Toggle the selected connection
        case "$result" in
            "$ACTIVE_PREFIX"*)
                nmcli connection down "$connection"
                ;;
            *)
                nmcli connection up "$connection"
                ;;
        esac
    }

    main() {
        connections=""
        result=""

        connections=$(list_wireguard_connections)
        result=$(echo "$connections" | rofi -dmenu)

        if [ -n "$result" ]; then
            toggle_wireguard_connection "$result"
        else
            echo "No connection selected."
        fi
    }

    main

  '';
}
