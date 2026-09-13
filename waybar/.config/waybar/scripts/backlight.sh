#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/lib.sh"

LOG="$HOME/.cache/waybar-backlight-debug.log"

log() {
  printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$1" >> "$LOG"
}

night_active() {
  pgrep -x hyprsunset > /dev/null 2>&1
}

status() {
  local cur max pct class tooltip label="BRT"
  cur=$(brightnessctl g)
  max=$(brightnessctl m)
  pct=$(( cur * 100 / max ))

  tooltip="Brightness: ${pct}% (click to toggle night light, scroll to adjust)"
  if night_active; then
    class="night-light"
    label="BRT(night)"
    tooltip="${tooltip} — night light ON"
  else
    class="normal"
  fi

  local line
  line=$(json_out "<b>$label</b> $(bar_graph "$pct") ${pct}%" "$tooltip" "$class")
  printf '%s\n' "$line"
  log "emit: $line"
}

# Prints status once, then again every time the kernel reports a backlight
# change (covers our own scroll actions as well as external ones, e.g.
# hardware brightness keys that write sysfs directly).
watch() {
  : > "$LOG"
  log "watch started, pid=$$"
  watch_loop 5 "change" "udevadm monitor -u -s backlight 2>>'$LOG'"
}

case "${1:-watch}" in
  up) brightnessctl set 5%+ > /dev/null ;;
  down) brightnessctl set 5%- > /dev/null ;;
  toggle-night)
    if night_active; then
      pkill hyprsunset
    else
      setsid -f hyprsunset -t 1000 > /dev/null 2>&1
    fi
    ;;
  status) status ;;
  watch) watch ;;
esac
