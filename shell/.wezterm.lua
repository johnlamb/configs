-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = 'GruvboxDark'
config.font = wezterm.font 'FiraCode Nerd Font Mono'
config.font_size = 13
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.window_decorations = "RESIZE"
config.adjust_window_size_when_changing_font_size = false
config.inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.3,
}

return config
