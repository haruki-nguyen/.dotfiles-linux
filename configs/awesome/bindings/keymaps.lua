local awful = require("awful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")

require("awful.autofocus")
require("awful.hotkeys_popup.keys")

globalkeys = gears.table.join(
	-- General group
	awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "Show help", group = "General" }),
	awful.key({ modkey }, "w", function()
		mymainmenu:show()
	end, { description = "Show main menu", group = "General" }),
	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "Reload awesome", group = "General" }),
	awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "Quit awesome", group = "General" }),
	awful.key({ modkey }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "Lua execute prompt", group = "General" }),

	-- Client group
	awful.key({ modkey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "Focus next by index", group = "Client" }),
	awful.key({ modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "Focus previous by index", group = "Client" }),
	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "Swap with next client by index", group = "Client" }),
	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "Swap with previous client by index", group = "Client" }),
	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "Jump to urgent client", group = "Client" }),
	awful.key({ modkey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "Go back", group = "Client" }),
	awful.key({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "Restore minimized", group = "Client" }),

	-- Tag group
	awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "View previous", group = "Tag" }),
	awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "View next", group = "Tag" }),
	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "Go back", group = "Tag" }),

	-- Screen group
	awful.key({ modkey, "Control" }, "j", function()
		awful.screen.focus_relative(1)
	end, { description = "Focus the next screen", group = "Screen" }),
	awful.key({ modkey, "Control" }, "k", function()
		awful.screen.focus_relative(-1)
	end, { description = "Focus the previous screen", group = "Screen" }),

	-- Layout group
	awful.key({ modkey }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "Increase master width factor", group = "Layout" }),
	awful.key({ modkey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "Decrease master width factor", group = "Layout" }),
	awful.key({ modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "Increase the number of master clients", group = "Layout" }),
	awful.key({ modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "Decrease the number of master clients", group = "Layout" }),
	awful.key({ modkey, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "Increase the number of columns", group = "Layout" }),
	awful.key({ modkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "Decrease the number of columns", group = "Layout" }),
	awful.key({ modkey }, "space", function()
		awful.layout.inc(1)
	end, { description = "Select next", group = "Layout" }),
	awful.key({ modkey, "Shift" }, "space", function()
		awful.layout.inc(-1)
	end, { description = "Select previous", group = "Layout" }),

	-- Launcher group
	awful.key({ modkey }, "Return", function()
		awful.spawn(terminal)
	end, { description = "Open a terminal", group = "Launcher" }),
	awful.key({ modkey }, "r", function()
		awful.screen.focused().mypromptbox:run()
	end, { description = "Run prompt", group = "Launcher" }),
	awful.key({ modkey }, "p", function()
		menubar.show()
	end, { description = "Show the menubar", group = "Launcher" })
)

clientkeys = gears.table.join(
	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "Toggle fullscreen", group = "Client" }),
	awful.key({ modkey, "Shift" }, "c", function(c)
		c:kill()
	end, { description = "Close", group = "Client" }),
	awful.key(
		{ modkey, "Control" },
		"space",
		awful.client.floating.toggle,
		{ description = "Toggle floating", group = "Client" }
	),
	awful.key({ modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "Move to master", group = "Client" }),
	awful.key({ modkey }, "o", function(c)
		c:move_to_screen()
	end, { description = "Move to screen", group = "Client" }),
	awful.key({ modkey }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "Toggle keep on top", group = "Client" }),
	awful.key({ modkey }, "n", function(c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end, { description = "Minimize", group = "Client" }),
	awful.key({ modkey }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "(un)maximize", group = "Client" }),
	awful.key({ modkey, "Control" }, "m", function(c)
		c.maximized_vertical = not c.maximized_vertical
		c:raise()
	end, { description = "(un)maximize vertically", group = "Client" }),
	awful.key({ modkey, "Shift" }, "m", function(c)
		c.maximized_horizontal = not c.maximized_horizontal
		c:raise()
	end, { description = "(un)maximize horizontally", group = "Client" })
)

-- Bind all key numbers to tags.
for i = 1, 9 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "View tag #" .. i, group = "Tag" }),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = "Toggle tag #" .. i, group = "Tag" }),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "Move focused client to tag #" .. i, group = "Tag" }),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "Toggle focused client on tag #" .. i, group = "Tag" })
	)
end

clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

root.keys(globalkeys)
