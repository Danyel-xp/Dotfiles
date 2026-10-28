WAL="$HOME/.cache/wal/colors.json"
CSS="$HOME/.config/wofi/style.css"

# Gera/troca as configurações automaticamente do style.css com as cores do Pywal apos ser executado.

color() {
    jq -r ".colors.$1" "$WAL"
}

cat > "$CSS" <<EOF
#window {
    background-color: $(color color0);
}

#input {
    background-color: $(color color8);
    margin: 10px;
    border: none;
    color: $(color color15);
}
#input > text {
    color: $(color color4);
}

#inner-box {
    background-color: $(color color0);
    margin: 3px;
}

#outer-box {
    margin: 3px;
    background-color: $(color color0);
}

#text {
    color: $(color color15);
    margin-left: 10px;
}

#entry:selected {
    margin: 5px;
    background-color: $(color color8);
    border: 1px solid $(color color4);
    border-radius: 6px;
}
EOF