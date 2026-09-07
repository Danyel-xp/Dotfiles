
---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "br",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 significa nenhuma modificação

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Exemplo de configuração específica para um dispositivo.
-- consulte https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ para mais inrformações

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = false, 
    },

    dwindle = {
        preserve_split = true, 
    },

    master = {
        new_status = "master",
    },
    
    scrolling = {
        fullscreen_on_one_column = true,
    },

})
