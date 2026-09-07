-- https://wiki.hypr.land/Configuring/Basics/Variables/

-------------------
---- APARÊNCIA ----
-------------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 5,

        border_size = 1,

        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        --Defina como true para permitir redimensionar janelas clicando e arrastando nas bordas e espaços.
        resize_on_border = true,

        -- Consulte https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ antes de ativar esta opção
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        -- Transparência das janelas focadas e não focadas.
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 6,
            passes    = 2,
            vibrancy  = 0.9,
        },
    },
})
