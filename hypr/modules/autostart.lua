-- https://wiki.hypr.land/Configuring/Basics/Autostart/
-- /home/Snow/.config/hypr/modules/autostart.lua

---------------------------------
--- INICIALIZAÇÃO AUTOMATICA  ---
---------------------------------

-- Execute automaticamente processo necessarios como (como daemons de notificações, barra de status, etc.)
-- Ou execute seus aplicativos favoritos ao iniciar:
--
hl.on("hyprland.start", function()
	--   hl.exec_cmd(terminal)
	--   hl.exec_cmd("nm-applet")
	--   hl.exec_cmd("waybar & hyprpaper")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("qs -p /home/Snow/.config/quickshell/music-panel >/tmp/music-panel.log 2>&1 &")
	hl.exec_cmd("waybar")
end)