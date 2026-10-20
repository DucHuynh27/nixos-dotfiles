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
      config.font = wezterm.font_with_fallback({ { family = "Maple Mono NF", harfbuzz_features = { "cv01=1", "cv03=1", "cv06=1", "cv09=1", "cv32=1", "cv42=1", "cv61=1", "cv66=1", "zero=1" } }, "Symbols Nerd Font" })
      config.font_size = 14.0
      config.hide_tab_bar_if_only_one_tab = true
      config.window_padding = { left = 10, right = 10, top = 10, bottom = 10 }
      config.window_decorations = "RESIZE" -- hides title bar but keeps resizability
      config.window_background_opacity = 0.7
      config.text_background_opacity = 0.7
      config.audible_bell = "Disabled"
      config.default_cursor_style = "BlinkingBar"
      config.cursor_blink_rate = 500

      -- Tab Bar (Powerline style)
      config.use_fancy_tab_bar = false
      config.tab_bar_at_bottom = false

      -- Scrollback
      config.scrollback_lines = 10000

      -- Catppuccin Frappe
      config.colors = {
        foreground = "#c6d0f5",
        background = "#303446",
        cursor_bg = "#f2d5cf",
        cursor_fg = "#303446",
        cursor_border = "#f2d5cf",
        selection_fg = "#c6d0f5",
        selection_bg = "#626880",
        ansi = { "#51576d", "#e78284", "#a6d189", "#e5c890", "#8caaee", "#f4b8e4", "#81c8be", "#b5bfe2" },
        brights = { "#626880", "#e78284", "#a6d189", "#e5c890", "#8caaee", "#f4b8e4", "#81c8be", "#a5adce" },
      }

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
