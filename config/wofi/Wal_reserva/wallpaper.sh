#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

selected=$(find "$WALLPAPER_DIR" -type f \
  \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) |
  while read -r wallpaper; do
    echo "img:$wallpaper:text:"
  done |
  wofi --dmenu \
    --allow-images \
    --style="$HOME/.config/wofi/wallpaper.css" \
    --define=image_size=150 \
    --columns=4 \
    --width=80% \
    --height=80% \
    --prompt "Wallpapers")

[ -z "$selected" ] && exit 0

wallpaper="${selected#img:}"
wallpaper="${wallpaper%%:text:*}"

awww img "$wallpaper" --transition-type any