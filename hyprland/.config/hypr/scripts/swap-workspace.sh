#!/usr/bin/env bash
# Swap the active workspace with workspace $1: current workspace takes on
# number $1 (and its windows go with it), while whatever was on $1 takes
# over the old number.
set -euo pipefail

target="$1"
cur="$(hyprctl activeworkspace -j | jq -r '.id')"

if [ "$cur" = "$target" ]; then
    exit 0
fi

# Pick an unused scratch workspace id to hold the current workspace's
# windows during the swap.
used_ids="$(hyprctl workspaces -j | jq -r '.[].id')"
scratch=1000
while echo "$used_ids" | grep -qx "$scratch"; do
    scratch=$((scratch + 1))
done

move_all() {
    local from="$1" to="$2"
    hyprctl -j clients | jq -r --argjson from "$from" \
        '.[] | select(.workspace.id == $from) | .address' |
        while read -r addr; do
            hyprctl dispatch movetoworkspacesilent "$to,address:$addr"
        done
}

move_all "$cur" "$scratch"
move_all "$target" "$cur"
move_all "$scratch" "$target"

hyprctl dispatch workspace "$target"
