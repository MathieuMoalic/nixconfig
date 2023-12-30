{pkgs, ...}: let
  wireguard-menu = pkgs.writeShellScriptBin "wireguard-menu" ''
        set -e
    # What to show in front of an active wireguard connection:
    ACTIVE_PREFIX="  ✓ "

    # What to show in front of an inactive wireguard connection:
    INACTIVE_PREFIX="    "
    # Display on standard output all wireguard connections, one per line. An
    # active wireguard connection is prefixed with `ACTIVE_PREFIX` and an inactive
    # one is prefixed with `INACTIVE_PREFIX`.
    list_wireguard_connections() {
        nmcli --get-values ACTIVE,NAME,TYPE connection show \
            | grep ':wireguard$' \
            | sed \
                  -e "s/^no:/$INACTIVE_PREFIX/" \
                  -e "s/^yes:/$ACTIVE_PREFIX/" \
                  -e 's/:wireguard$//'
    }

    # Take a line as displayed by `list_wireguard_connections()` as argument and
    # use nmcli to toggle the corresponding connection.
    toggle_wireguard_connection() {
        result="$1"
        connection=""

        connection=$(extract_connection_name_from_result "$result")
        echo $connection

        case "$result" in
            $ACTIVE_PREFIX*)
                echo nmcli connection down "$connection"
                nmcli connection down "$connection"
                ;;
            *)
                echo nmcli connection up "$connection"
                nmcli connection up "$connection"
                ;;
        esac
    }

    # Take a line as displayed by `list_wireguard_connections()` as argument and
    # remove `ACTIVE_PREFIX` or `INACTIVE_PREFIX` to only display the
    # connection name.
    extract_connection_name_from_result() {
        result="$1"

        # Remove ACTIVE_PREFIX and INACTIVE_PREFIX
        result="$result#$ACTIVE_PREFIX}"
        result="$result#$INACTIVE_PREFIX}"

        # Trim leading whitespace
        echo "$result#'$result%%[![:space:]]*'"
    }

    # Execute the `rofi` command. The first argument of the function is
    # used as lines to select from.
    start_rofi() {
        content="$1"
        echo "$content" | rofi -dmenu
    }

    # List the wireguard connections and let the user toggle one using rofi.
    main() {
        connections=""
        result=""

        connections=$(list_wireguard_connections)
        result=$(start_rofi "$connections")

        toggle_wireguard_connection "$result"
    }

    main

  '';
in {
  home.packages = [
    wireguard-menu
  ];
}
