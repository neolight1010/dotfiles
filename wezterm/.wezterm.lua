local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = 'Aura (Gogh)'
config.window_decorations = 'TITLE | RESIZE'
config.font = wezterm.font("BlexMono Nerd Font Mono")
config.font_size = 14
config.window_close_confirmation = 'NeverPrompt'
config.hide_mouse_cursor_when_typing = false
config.hide_tab_bar_if_only_one_tab = true

return config
