#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/lib.sh"

ORDER=(performance balanced power-saver)

capitalize() {
  sed 's/-/ /g' <<< "$1" | \
    awk '{for (i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}'
}

status() {
  local profile label
  profile=$(powerprofilesctl get)
  label=$(capitalize "$profile")
  json_out "$label" "Power profile: $label (click to cycle)" "$profile"
}

cycle() {
  local current next_index i
  current=$(powerprofilesctl get)
  for i in "${!ORDER[@]}"; do
    if [[ "${ORDER[$i]}" == "$current" ]]; then
      next_index=$(( (i + 1) % ${#ORDER[@]} ))
      powerprofilesctl set "${ORDER[$next_index]}"
      return
    fi
  done
  powerprofilesctl set "${ORDER[0]}"
}

# Prints status once, then again the instant the daemon's active profile
# changes (our own clicks or anything else that changes it, e.g. GNOME settings).
watch() {
  watch_loop 10 "ActiveProfile" \
    "dbus-monitor --system \"type='signal',interface='org.freedesktop.DBus.Properties',path='/net/hadess/PowerProfiles'\" 2>/dev/null"
}

case "${1:-watch}" in
  toggle) cycle ;;
  status) status ;;
  watch) watch ;;
esac
