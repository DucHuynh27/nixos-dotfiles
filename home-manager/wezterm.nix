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
      config.font = wezterm.font_with_fallback({ wezterm.font("Maple Mono NF", { harfbuzz_features = { "cv01=1", "cv03=1", "cv06=1", "cv09=1", "cv32=1", "cv42=1", "cv61=1", "cv66=1", "zero=1" } }), "Symbols Nerd Font" })
      config.font_size = 14.0
      config.hide_tab_bar_if_only_one_tab = true
      config.window_padding = { left = 10, right = 10, top = 10, bottom = 10 }
      config.window_decorations = "RESIZE" -- hides title bar but keeps resizability
      config.audible_bell = "Disabled"
      config.default_cursor_style = "BlinkingBar"
      config.cursor_blink_rate = 500
      
      -- Tab Bar (Powerline style)
      config.use_fancy_tab_bar = false
      config.tab_bar_at_bottom = false
      
      -- Scrollback
      config.scrollback_lines = 10000

      -- Load Matugen Colors
      -- Sử dụng bảng màu chính thức của Noctalia (Auto-generated TOML)
      local theme_path = "/home/hinne/.config/wezterm/colors/Noctalia.toml"
      wezterm.add_to_config_reload_watch_list(theme_path)
      config.color_scheme = "Noctalia"

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
        
        -- Tabs
        { key = 'T', mods = 'CTRL|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },
        { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
        { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(1) },
        { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
        { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
        
        -- Window / Pane Management
        { key = 'W', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane { confirm = false } },
        
        -- Search
        { key = 'F', mods = 'CTRL|SHIFT', action = act.Search 'CurrentSelectionOrEmptyString' },
        
        -- Zoom (Stack)
        { key = 'Z', mods = 'CTRL|SHIFT', action = act.TogglePaneZoomState },
      }
      
      return config
    '';
  };
}
