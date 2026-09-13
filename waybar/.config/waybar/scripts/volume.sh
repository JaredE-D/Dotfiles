#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/lib.sh"

SINK=@DEFAULT_AUDIO_SINK@
LIMIT=1.5   # allow amplification up to 150% before clipping gets bad

status() {
  local info pct class label
  info=$(wpctl get-volume "$SINK")
  pct=$(awk '{printf "%d", $2 * 100}' <<< "$info")
  label="VOL"

  if [[ $info == *MUTED* ]]; then
    class="muted"
    label="VOL(muted)"
  else
    class="normal"
  fi

  json_out "<b>$label</b> $(bar_graph "$pct") ${pct}%" "Volume: ${pct}% (click to mute, scroll to adjust)" "$class"
}

# Prints status once, then again every time PipeWire reports a sink change
# (covers our own clicks/scrolls as well as external changes, e.g. media keys).
watch() {
  watch_loop 5 "on sink" "pactl subscribe 2>/dev/null"
}

case "${1:-watch}" in
  up) wpctl set-volume -l "$LIMIT" "$SINK" 5%+ ;;
  down) wpctl set-volume -l "$LIMIT" "$SINK" 5%- ;;
  toggle) wpctl set-mute "$SINK" toggle ;;
  status) status ;;
  watch) watch ;;
esac
