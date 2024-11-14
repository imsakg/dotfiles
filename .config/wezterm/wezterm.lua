local wezterm = require("wezterm")
local features = require("features")
local act = wezterm.action
local config = wezterm.config_builder()
local G = features.getLuaFromTOML()
local scheme

function get_appearance(appearance)
	if appearance:find("Dark") then
		return "Dark"
	else
		return "Light"
	end
end

wezterm.on("window-resized", function(window, pane) end)
wezterm.on("window-config-reloaded", function(window, pane)
	-- If there are no overrides, this is our first time seeing
	-- this window, so we can pick a random scheme.

	local overrides = window:get_config_overrides() or {}
	local appearance = get_appearance(window:get_appearance())
	local theme = features.get_theme()
	-- if appearance == "Dark" then
	-- 	G.appearance = appearance
	-- 	scheme = wezterm.color.get_builtin_schemes()[theme]
	-- 	overrides.color_scheme = scheme
	-- 	window:set_config_overrides(overrides)
	-- 	features.set_appearance(appearance)
	-- else
	-- 	G.appearance = appearance
	-- 	scheme = wezterm.color.get_builtin_schemes()[theme]
	-- 	overrides.color_scheme = scheme
	-- 	window:set_config_overrides(overrides)
	-- 	features.set_appearance(appearance)
	-- end
	-- if overrides.color_scheme ~= scheme then
	-- end
end)

-- FONTS
local font
if G.font.family == "Default" then
	font = wezterm.font_with_fallback({})
else
	font = wezterm.font_with_fallback({
		{ family = G.font.family, weight = G.font.weight or 400, italic = false },
	})
end

config.font_rules = { { intensity = "Bold", font = font }, { intensity = "Normal", font = font } }
config.font_size = G.font.font_size or 16

if G.OLED then
	G.background = "#000000"
end

-- scheme.background = G.background or scheme.background
if G.appearance == "Dark" then
	scheme = wezterm.color.get_builtin_schemes()[G.colorscheme_dark]
	-- for colorscheme_dark, overrides in pairs({
	-- 	["Default (dark) (terminal.sexy)"] = { background = "#121212" },
	-- 	["Poimandres"] = { background = "#0E0F15" },
	-- 	["catppuccin-mocha"] = { background = "#191926" },
	-- 	["rose-pine"] = { background = "#12101A" },
	-- 	["rose-pine-moon"] = { background = "#12101A" },
	-- 	["tokyonight"] = { background = "#15161F" },
	-- 	["tokyonight_moon"] = { background = "#15161F" },
	-- 	["Gruvbox Material (Gogh)"] = { background = "#0f0f0f" },
	-- 	["Nightfly (Gogh)"] = { background = "#010F1A" },
	-- }) do
	-- 	if G.colorscheme_dark == colorscheme_dark then
	-- 		for property, value in pairs(overrides) do
	-- 			scheme[property] = value
	-- 			scheme.background = G.background or value
	-- 		end
	-- 	end
	-- end
else
	scheme = wezterm.color.get_builtin_schemes()[G.colorscheme_light]
	-- for colorscheme_light, overrides in pairs({
	-- 	["Default (dark) (terminal.sexy)"] = { background = "#121212" },
	-- 	["Poimandres"] = { background = "#0E0F15" },
	-- 	["catppuccin-mocha"] = { background = "#191926" },
	-- 	["rose-pine"] = { background = "#12101A" },
	-- 	["rose-pine-moon"] = { background = "#12101A" },
	-- 	["tokyonight"] = { background = "#15161F" },
	-- 	["tokyonight_moon"] = { background = "#15161F" },
	-- 	["Gruvbox Material (Gogh)"] = { background = "#0f0f0f" },
	-- 	["Nightfly (Gogh)"] = { background = "#010F1A" },
	-- }) do
	-- 	if G.colorscheme_light == colorscheme_light then
	-- 		for property, value in pairs(overrides) do
	-- 			scheme[property] = value
	-- 			scheme.background = G.background or value
	-- 		end
	-- 	end
	-- end
end

config.color_scheme = "CustomTheme"
config.color_schemes = { ["CustomTheme"] = scheme }
-- config.command_palette_bg_color = scheme.background
-- config.command_palette_fg_color = scheme.foreground

config.font_size = 14
-- config.font_weight
config.cursor_blink_rate = 800

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}

-- CURSOR
config.cursor_blink_ease_in = "Linear"
config.cursor_blink_ease_out = "Linear"
config.hide_mouse_cursor_when_typing = true
config.animation_fps = 60
config.tiling_desktop_environments = { "X11 i3" }

-- ENV
config.set_environment_variables = { PATH = "/opt/homebrew/bin:" .. os.getenv("PATH") }

config.window_padding = G.padding
config.macos_window_background_blur = 50
config.window_background_opacity = G.opacity
config.adjust_window_size_when_changing_font_size = false
-- config.initial_cols = 140
-- config.initial_rows = 40
config.window_decorations = "RESIZE" -- remove window decorations
config.enable_scroll_bar = false
config.window_frame = { font = wezterm.font({ family = G.font.family, weight = G.font.weight }) }
config.command_palette_font_size = G.font.font_size or 16
config.front_end = "WebGpu"
config.audible_bell = "Disabled" -- disable sounds when at the end of doc

config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

wezterm.on("update-right-status", function(window, pane)
	local name = window:active_key_table()
	if name then
		name = "TABLE: " .. name
	end
	window:set_right_status(name or "")
end)

config.leader = { key = "k", mods = "CMD" }
config.keys = {
	{
		key = "c",
		mods = "CMD",
		action = wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
	},
	{
		key = "|",
		mods = "CMD",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "\\",
		mods = "CMD",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{ key = "k", mods = "CMD|CTRL", action = wezterm.action_callback(features.theme_switcher) },
	{ key = "f", mods = "CMD|CTRL", action = wezterm.action_callback(features.font_switcher) },
	{ key = "p", mods = "CMD", action = wezterm.action.ShowTabNavigator },
	{ key = "P", mods = "CMD", action = wezterm.action.ShowLauncher },
	-- Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
	{
		key = "LeftArrow",
		mods = "OPT",
		action = act.SendKey({
			key = "b",
			mods = "ALT",
		}),
	},
	{
		key = "RightArrow",
		mods = "OPT",
		action = act.SendKey({ key = "f", mods = "ALT" }),
	},
	{ key = "o", mods = "CMD|CTRL", action = wezterm.action_callback(features.toggleOLED) },
	{
		key = "f",
		mods = "CMD",
		action = act.Search({ CaseInSensitiveString = "" }),
	},
	-- CTRL+SHIFT+Space, followed by 'r' will put us in resize-pane
	-- mode until we cancel that mode.
	{
		key = "r",
		mods = "CMD",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},
	{ key = "b", mods = "CMD|CTRL", action = features.global_bg() },

	-- CTRL+SHIFT+Space, followed by 'a' will put us in activate-pane
	-- mode until we press some other key or until 1 second (1000ms)
	-- of time elapses
	{
		key = "a",
		mods = "CMD",
		action = act.ActivateKeyTable({
			name = "activate_pane",
			one_shot = false,
			-- timeout_milliseconds = 1000,
		}),
	},
}

config.key_tables = {
	-- Defines the keys that are active in our resize-pane mode.
	-- Since we're likely to want to make multiple adjustments,
	-- we made the activation one_shot=false. We therefore need
	-- to define a key assignment for getting out of this mode.
	-- 'resize_pane' here corresponds to the name="resize_pane" in
	-- the key assignments above.
	resize_pane = {
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },

		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },

		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },

		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},

	-- Defines the keys that are active in our activate-pane mode.
	-- 'activate_pane' here corresponds to the name="activate_pane" in
	-- the key assignments above.
	activate_pane = {
		{ key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
		{ key = "h", action = act.ActivatePaneDirection("Left") },

		{ key = "RightArrow", action = act.ActivatePaneDirection("Right") },
		{ key = "l", action = act.ActivatePaneDirection("Right") },

		{ key = "UpArrow", action = act.ActivatePaneDirection("Up") },
		{ key = "k", action = act.ActivatePaneDirection("Up") },

		{ key = "DownArrow", action = act.ActivatePaneDirection("Down") },
		{ key = "j", action = act.ActivatePaneDirection("Down") },
		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
}

return config
