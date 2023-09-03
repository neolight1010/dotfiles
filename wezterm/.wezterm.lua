local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.font = wezterm.font 'Jetbrains Mono'
config.color_scheme = 'UnderTheSea'
config.window_decorations = 'RESIZE'

return config
