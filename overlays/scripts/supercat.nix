{pkgs, ...}:
pkgs.writeShellApplication {
  name = "supercat";
  runtimeInputs = [pkgs.coreutils pkgs.ncurses];
  text = ''
    set -euo pipefail

    if [ "$#" -eq 0 ]; then
      echo "usage: hcat FILE..." >&2
      exit 2
    fi

    print_header() {
      local path="$1"

      # Prefer relative path if possible
      if command -v realpath >/dev/null 2>&1; then
        local rel
        rel="$(realpath --relative-to="$PWD" "$path" 2>/dev/null || true)"
        if [ -n "''${rel:-}" ]; then
          path="$rel"
        fi
      fi

      # Determine width from terminal, default to 80
      local cols="''${COLUMNS:-}"
      if [ -z "''${cols}" ]; then
        cols="$(tput cols 2>/dev/null || echo 80)"
      fi
      if [ "''${cols}" -lt 20 ] 2>/dev/null; then
        cols=80
      fi

      local prefix="### "
      local suffix=" #####"
      local middle=$(( cols - ''${#prefix} - ''${#suffix} ))

      local border
      border="$(printf '%*s' "''${cols}" "" | tr ' ' '#')"

      # Fit/truncate the path (keep the end, add ellipsis if needed)
      local p="''${path}"
      if [ ''${#p} -gt "''${middle}" ]; then
        local keep=$(( middle - 1 ))
        if [ "''${keep}" -lt 1 ]; then keep=1; fi
        p="…''${p: -''${keep}}"
      fi

      local pad=$(( middle - ''${#p} ))

      printf "%s\n" "''${border}"
      printf "%s%s%*s%s\n" "''${prefix}" "''${p}" "''${pad}" "" "''${suffix}"
      printf "%s\n\n" "''${border}"
    }

    for f in "$@"; do
      if [ ! -e "$f" ]; then
        echo "hcat: $f: No such file or directory" >&2
        continue
      fi
      print_header "$f"
      cat -- "$f"
      printf "\n"
    done
  '';
}
