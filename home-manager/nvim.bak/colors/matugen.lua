vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "matugen"

local function read_kitty_colors()
  local file = io.open(vim.fn.expand("~/.config/kitty/themes/noctalia.conf"), "r")
  if not file then return nil end
  local colors = {}
  for line in file:lines() do
    local key, hex = line:match("^([a-z0-9_]+)%s+(#%x+)$")
    if key and hex then
      colors[key] = hex
    end
  end
  file:close()
  return colors
end

local function apply_theme()
  local c = read_kitty_colors()
  if c and c.color0 then
    require('base16-colorscheme').setup({
      base00 = c.background or c.color0,
      base01 = c.color0,
      base02 = c.selection_background or c.color0,
      base03 = c.color8,
      base04 = c.color7,
      base05 = c.color7,
      base06 = c.color15,
      base07 = c.color15,
      base08 = c.color1,
      base09 = c.color3,
      base0A = c.color3,
      base0B = c.color2,
      base0C = c.color6,
      base0D = c.color4,
      base0E = c.color5,
      base0F = c.color1,
    })
  else
    -- Fallback
    require('base16-colorscheme').setup({
      base00 = '#1e1e2e', base01 = '#313244', base02 = '#3a3b50', base03 = '#65697e',
      base04 = '#9399b2', base05 = '#cdd6f4', base06 = '#cdd6f4', base07 = '#cdd6f4',
      base08 = '#f38ba8', base09 = '#cba6f7', base0A = '#f5c2e7', base0B = '#89b4fa',
      base0C = '#bb8af4', base0D = '#85b1fa', base0E = '#ed91d4', base0F = '#c8043a',
    })
  end

  local hi = function(group, opts) vim.api.nvim_set_hl(0, group, opts) end
  hi('Normal', { bg = 'NONE' })
  hi('NormalNC', { bg = 'NONE' })
  hi('SignColumn', { bg = 'NONE' })
  hi('EndOfBuffer', { bg = 'NONE' })
  hi('NeoTreeNormal', { bg = 'NONE' })
  hi('NeoTreeNormalNC', { bg = 'NONE' })
  hi('NeoTreeWinSeparator', { fg = c and c.color8 or 'NONE', bg = 'NONE' })
  hi('WinSeparator', { fg = c and c.color8 or 'NONE', bg = 'NONE' })
  hi('NormalFloat', { bg = 'NONE' })
  hi('FloatBorder', { bg = 'NONE' })
  hi('LazyNormal', { bg = 'NONE' })
  hi('MasonNormal', { bg = 'NONE' })
  
  hi('TelescopeNormal',         { fg = c and c.color7 or 'NONE', bg = 'NONE' })
  hi('TelescopeBorder',         { fg = c and c.color8 or 'NONE', bg = 'NONE' })
  hi('TelescopePromptNormal',   { fg = c and c.color7 or 'NONE', bg = 'NONE' })
  hi('TelescopePromptBorder',   { fg = c and c.color8 or 'NONE', bg = 'NONE' })
  hi('TelescopePromptPrefix',   { fg = c and c.color4 or 'NONE', bg = 'NONE' })
end

apply_theme()

-- Reload on SIGUSR1
if not _G.__matugen_signal_started then
  _G.__matugen_signal_started = true
  local signal = vim.uv.new_signal()
  signal:start(
    'sigusr1',
    vim.schedule_wrap(function()
      vim.cmd("colorscheme matugen")
    end)
  )
end
