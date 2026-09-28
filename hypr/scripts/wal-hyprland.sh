#!/bin/bash
#Quando trocar o wallpaper com o hyprquickpaper esse script troca automaticamente as cores das bordas da janela.

WAL="$HOME/.cache/wal/colors.json"

color1=$(jq -r '.colors.color1' "$WAL")
color4=$(jq -r '.colors.color4' "$WAL")
color8=$(jq -r '.colors.color8' "$WAL")

hex_to_rgba() {
    local hex="${1#\#}"
    echo "rgba(${hex}ff)"
}

c1=$(hex_to_rgba "$color1")
c4=$(hex_to_rgba "$color4")
c8=$(hex_to_rgba "$color8")

hyprctl eval "hl.config({
    general = {
        col = {
            active_border = {
                colors = { \"$c4\", \"$c1\" },
                angle = 45
            },
            inactive_border = \"$c8\"
        }
    }
})"