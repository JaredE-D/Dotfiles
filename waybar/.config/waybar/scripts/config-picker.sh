#!/usr/bin/env bash
set -euo pipefail

choice=$(printf 'Waybar\nHyprland\n' | rofi -dmenu -p "Edit config")

case "$choice" in
  Waybar) alacritty -e nvim ~/.config/waybar/config.jsonc ;;
  Hyprland) alacritty -e nvim ~/.config/hypr/hyprland.conf ;;
esac
