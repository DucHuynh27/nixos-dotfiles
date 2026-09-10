{
  config,
  pkgs,
  ...
}: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local act = wezterm.action
      local config = wezterm.config_builder()
      
      -- Font & Appearance
      config.font = wezterm.font 'Maple Mono NF'
      config.font_size = 14.0
      config.window_padding = { left = 10, right = 10, top = 10, bottom = 10 }
      config.window_decorations = "RESIZE" -- hides title bar but keeps resizability
      config.audible_bell = "Disabled"
      
      -- Tab Bar (Powerline style)
      config.use_fancy_tab_bar = false
      config.tab_bar_at_bottom = false
      
      -- Scrollback
      config.scrollback_lines = 10000

      -- Load Matugen Colors
      local theme_path = "/home/hinne/.config/wezterm/colors/noctalia.lua"
      wezterm.add_to_config_reload_watch_list(theme_path)
      
      local colors = {}
      local file = io.open(theme_path, "r")
      if file then
        file:close()
        colors = dofile(theme_path)
        config.colors = colors
      end

      -- Keybindings
      config.disable_default_key_bindings = false
      config.keys = {
        -- Splits (Ctrl+Shift+Enter for Horizontal, Ctrl+Shift+O for Vertical)
        { key = 'Enter', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
        { key = 'O', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
        
        -- Move between panes
        { key = 'H', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Left' },
        { key = 'J', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Down' },
        { key = 'K', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Up' },
        { key = 'L', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Right' },
        
        -- Zoom (Stack)
        { key = 'Z', mods = 'CTRL|SHIFT', action = act.TogglePaneZoomState },
      }
      
      return config
    '';
  };
}
