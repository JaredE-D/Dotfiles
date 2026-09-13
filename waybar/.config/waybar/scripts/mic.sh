#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/lib.sh"

SOURCE=@DEFAULT_AUDIO_SOURCE@
LIMIT=1.0   # cap mic gain at 100%

status() {
  local info pct class label
  info=$(wpctl get-volume "$SOURCE")
  pct=$(awk '{printf "%d", $2 * 100}' <<< "$info")
  label="MIC"

  if [[ $info == *MUTED* ]]; then
    class="muted"
    label="MIC(muted)"
  else
    class="normal"
  fi

  json_out "<b>$label</b> $(bar_graph "$pct") ${pct}%" "Mic: ${pct}% (click to mute, scroll to adjust)" "$class"
}

# Prints status once, then again every time PipeWire reports a source change
# (covers our own clicks/scrolls as well as external changes, e.g. media keys).
watch() {
  watch_loop 5 "on source" "pactl subscribe 2>/dev/null"
}

case "${1:-watch}" in
  up) wpctl set-volume -l "$LIMIT" "$SOURCE" 5%+ ;;
  down) wpctl set-volume -l "$LIMIT" "$SOURCE" 5%- ;;
  toggle) wpctl set-mute "$SOURCE" toggle ;;
  status) status ;;
  watch) watch ;;
esac
