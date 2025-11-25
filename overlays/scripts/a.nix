{pkgs, ...}:
pkgs.writeShellApplication {
  name = "a";
  text = ''
    KEY="$1"
    MODS="NULL"
    TARGET_TITLE="."

    target_addr=$(
            hyprctl -j clients |
                    jq -r --arg title "$TARGET_TITLE" '
          .[] | select(.title == $title) | .address
        ' |
                    head -n 1
    )

    if [ -z "$target_addr" ]; then
      notify-send "Can't find window with title: $TARGET_TITLE"
      exit 2
    fi
    hyprctl dispatch sendshortcut "$MODS, $KEY, address:$target_addr"

  '';
}
