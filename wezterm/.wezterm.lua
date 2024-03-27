local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = 'Horizon Dark (base16)'
config.window_decorations = 'RESIZE'

config.window_close_confirmation = 'NeverPrompt'

return config
