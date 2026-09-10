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
      -- Sync colors directly from Kitty's theme file so it works with Noctalia Community Themes
      local theme_path = "/home/hinne/.config/kitty/themes/noctalia.conf"
      wezterm.add_to_config_reload_watch_list(theme_path)
      
      local colors = { ansi = {}, brights = {}, tab_bar = { active_tab = {}, inactive_tab = {} } }
      local file = io.open(theme_path, "r")
      if file then
        for line in file:lines() do
          local key, value = line:match("^([%w_]+)%s+(#[%w]+)")
          if key and value then
            if key == "foreground" then colors.foreground = value
            elseif key == "background" then colors.background = value; colors.tab_bar.background = value
            elseif key == "selection_foreground" then colors.selection_fg = value
            elseif key == "selection_background" then colors.selection_bg = value
            elseif key == "cursor" then colors.cursor_bg = value; colors.cursor_border = value
            elseif key == "cursor_text_color" then colors.cursor_fg = value
            elseif key == "active_tab_foreground" then colors.tab_bar.active_tab.fg_color = value
            elseif key == "active_tab_background" then colors.tab_bar.active_tab.bg_color = value
            elseif key == "inactive_tab_foreground" then colors.tab_bar.inactive_tab.fg_color = value
            elseif key == "inactive_tab_background" then colors.tab_bar.inactive_tab.bg_color = value
            elseif key:match("^color(%d+)$") then
              local num = tonumber(key:match("^color(%d+)$"))
              if num >= 0 and num <= 7 then colors.ansi[num + 1] = value
              elseif num >= 8 and num <= 15 then colors.brights[num - 7] = value end
            end
          end
        end
        file:close()
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
