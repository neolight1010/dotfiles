local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = 'Kasugano (terminal.sexy)'
config.window_decorations = 'RESIZE'
config.font = wezterm.font("GohuFont uni14 Nerd Font Mono")
config.font_size = 16

config.window_close_confirmation = 'NeverPrompt'

return config
