
--------------------------------
---- JANELAS E AREA DE TRABALHO ----
--------------------------------

-- consulte https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- e https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Exemplos de regras de janela úteis.

local suppressMaximizeRule = hl.window_rule({
-- Ignore solicitações de maximização de todos os aplicativos. Você provavelmente vai gostar disso.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Corrige alguns problemas de arrastar janelas com o XWayland.
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name = "vscode --fullscreen",
    match = {
        class = "code"
    },
    fullscreen = true,
})
