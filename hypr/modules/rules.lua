--------------------------------
---- JANELAS E AREA DE TRABALHO ----
--------------------------------

-- consulte https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- e https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Exemplos de regras de janela úteis.

local suppressMaximizeRule = hl.window_rule({
	-- Ignore solicitações de maximização de todos os aplicativos. Você provavelmente vai gostar disso.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Corrige alguns problemas de arrastar janelas com o XWayland.
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

-- fullscreen no code quando inicialo
hl.window_rule({
	name = "vscode --fullscreen",
	match = {
		class = "code",
	},
	fullscreen = true,
})

-- -- fullscreen no nvim quando inicialo
hl.on("window.title", function(w)
	if w.class ~= "kitty" then
		return
	end
	if w.title:match("^nvim") then
		hl.dispatch(hl.dsp.window.fullscreen({ action = "set", window = w }))
	else
		hl.dispatch(hl.dsp.window.fullscreen({ action = "unset", window = w }))
	end
end)
