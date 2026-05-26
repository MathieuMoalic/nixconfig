{...}: {
  flake.overlays.toggle-audio-port = final: _: {
    toggle-audio-port = final.writeShellApplication {
      name = "toggle-audio-port";

      runtimeInputs = [
        final.pulseaudio # pactl
        final.gawk
        final.libnotify # notify-send
      ];

      text = ''
        sink="alsa_output.pci-0000_0a_00.4.analog-stereo"

        current="$(pactl list sinks | awk -v sink="$sink" '
          $1 == "Name:" && $2 == sink { in_sink = 1 }
          in_sink && $1 == "Active" && $2 == "Port:" { print $3; exit }
          $1 == "Name:" && $2 != sink { in_sink = 0 }
        ')"

        case "$current" in
          analog-output-headphones)
            pactl set-sink-port "$sink" analog-output-lineout
            notify-send "Audio output" "Rear jack / AKG K361"
            ;;
          *)
            pactl set-sink-port "$sink" analog-output-headphones
            notify-send "Audio output" "Front jack / speakers"
            ;;
        esac
      '';
    };
  };
}
