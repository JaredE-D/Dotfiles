#!/usr/bin/env bash
# Shared helpers for waybar custom module scripts.

bar_graph() {
  local pct=${1:-0} width=${2:-5}
  (( pct < 0 )) && pct=0
  (( pct > 100 )) && pct=100
  local filled=$(( pct * width / 100 ))
  local empty=$(( width - filled ))
  local out=""
  for ((i = 0; i < filled; i++)); do out+="▮"; done
  for ((i = 0; i < empty; i++)); do out+="▯"; done
  printf '%s' "$out"
}

json_out() {
  local text=$1 tooltip=$2 class=$3
  printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' \
    "${text//\"/\\\"}" "${tooltip//\"/\\\"}" "$class"
}

# Runs an event-driven watch loop for a waybar continuous-stream custom
# module: prints status once, then again whenever $event_cmd emits a line
# containing $match, plus a periodic fallback poll in case the event source
# never fires. Handles cleanup so that when waybar kills/restarts this
# module's process (e.g. after a signal-triggered refresh), no child
# process is left running against a closed pipe.
#
# Usage: watch_loop <fallback-interval-seconds> <match-substring> <event-cmd-string>
# event-cmd-string is run via `bash -c`, so it may use redirection/quoting.
# Requires the caller to define a `status` function.
watch_loop() {
  local fallback_interval=$1 match=$2 event_cmd=$3

  # If waybar closes its end of our stdout pipe, exit quietly instead of
  # letting a write failure (or any error it triggers downstream, e.g. a
  # coproc that fails to start against a dead fd) cascade into a noisy
  # `set -e`/`set -u` crash.
  trap 'exit 0' PIPE ERR

  status
  start_fallback_poll "$fallback_interval" status

  coproc EVENTS { stdbuf -oL bash -c "$event_cmd"; }
  trap 'kill "$FALLBACK_POLL_PID" "$EVENTS_PID" 2>/dev/null' EXIT

  local line
  while read -r line <&"${EVENTS[0]}"; do
    [[ -z "$match" || $line == *"$match"* ]] && status
  done
}

# Internal: used by watch_loop. Re-runs $2... every $1 seconds in the
# background as a safety net in case the event source never fires or dies
# silently.
start_fallback_poll() {
  local interval=$1
  shift
  ( while true; do sleep "$interval"; "$@"; done ) &
  FALLBACK_POLL_PID=$!
}
