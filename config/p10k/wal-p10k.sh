#!/bin/bash

WAL="$HOME/.cache/wal/colors.json"
P10K="$HOME/.config/p10k/wal-colors.zsh"

# Verifica se o Pywal gerou as cores
if [[ ! -f "$WAL" ]]; then
    exit 1
fi

# Pega as cores do Pywal
color1=$(jq -r '.colors.color1' "$WAL")
color2=$(jq -r '.colors.color2' "$WAL")
color3=$(jq -r '.colors.color3' "$WAL")
color4=$(jq -r '.colors.color4' "$WAL")
color5=$(jq -r '.colors.color5' "$WAL")
color6=$(jq -r '.colors.color6' "$WAL")
color7=$(jq -r '.colors.color7' "$WAL")
color8=$(jq -r '.colors.color8' "$WAL")

cat > "$P10K" <<EOF
# Cores geradas automaticamente pelo Pywal

typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND='$color4'

typeset -g POWERLEVEL9K_DIR_FOREGROUND='$color4'
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='$color6'
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND='$color5'

typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='$color2'
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='$color2'
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='$color3'

typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='$color2'
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='$color1'

typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND='$color2'
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='$color1'

typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='$color8'
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='$color5'

typeset -g POWERLEVEL9K_DIRENV_FOREGROUND='$color3'
typeset -g POWERLEVEL9K_ASDF_FOREGROUND='$color6'

typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='$color6'
typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND='$color6'
typeset -g POWERLEVEL9K_PYENV_FOREGROUND='$color6'

typeset -g POWERLEVEL9K_GOENV_FOREGROUND='$color6'
typeset -g POWERLEVEL9K_NODENV_FOREGROUND='$color6'
typeset -g POWERLEVEL9K_NVM_FOREGROUND='$color6'
typeset -g POWERLEVEL9K_NODEENV_FOREGROUND='$color6'

typeset -g POWERLEVEL9K_RBENV_FOREGROUND='$color6'
typeset -g POWERLEVEL9K_RVM_FOREGROUND='$color6'
typeset -g POWERLEVEL9K_FVM_FOREGROUND='$color6'
typeset -g POWERLEVEL9K_LUAENV_FOREGROUND='$color6'

typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND='$color4'
typeset -g POWERLEVEL9K_TIME_FOREGROUND='$color8'

typeset -g POWERLEVEL9K_YAZI_FOREGROUND='$color5'
typeset -g POWERLEVEL9K_RANGER_FOREGROUND='$color5'
typeset -g POWERLEVEL9K_NNN_FOREGROUND='$color5'
typeset -g POWERLEVEL9K_LF_FOREGROUND='$color5'
typeset -g POWERLEVEL9K_XPLR_FOREGROUND='$color5'
typeset -g POWERLEVEL9K_VIM_SHELL_FOREGROUND='$color5'
typeset -g POWERLEVEL9K_MIDNIGHT_COMMANDER_FOREGROUND='$color5'
EOF