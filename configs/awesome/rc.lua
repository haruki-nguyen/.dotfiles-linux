pcall(require, "luarocks.loader")

local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")

require("awful.autofocus")

-- ERROR HANDLING
-- Check if awesome encountered an error during startup and fell back to another config
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end
-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end

-- VARIABLE DEFINITIONS
beautiful.init("~/.config/awesome/theme.lua")

terminal = "kitty"
editor = "nvim" or "vi" or "nano"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"

awful.layout.layouts = {
	awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.fair,
	awful.layout.suit.max,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.magnifier,
}
mymainmenu = awful.menu({
	items = {
		{ "Edit configs", editor_cmd .. " " .. awesome.conffile },
	},
})
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
mykeyboardlayout = awful.widget.keyboardlayout()

-- RUN KEYMAPS
require("bindings.keymaps")
require("bindings.mouse")

-- RUN BAR
require("bar")

-- RUN RULES
require("rules")

-- RUN SIGNALS
require("signals")
