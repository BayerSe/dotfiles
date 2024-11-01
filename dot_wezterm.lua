local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font 'Monaco'
config.font_size = 13
config.color_scheme = 'iTerm2 Pastel Dark Background'
config.hide_tab_bar_if_only_one_tab = true

return config
