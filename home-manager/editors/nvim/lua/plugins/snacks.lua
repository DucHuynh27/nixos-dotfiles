return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Tìm file", action = ":lua require('fzf-lua').files()" },
            { icon = " ", key = "g", desc = "Tìm chữ trong code", action = ":lua require('fzf-lua').live_grep()" },
            { icon = " ", key = "r", desc = "File gần đây", action = ":lua require('fzf-lua').oldfiles()" },
            { icon = " ", key = "c", desc = "Cấu hình Neovim", action = ":lua require('fzf-lua').files({ cwd = vim.fn.stdpath('config') })" },
            { icon = "󰒲 ", key = "l", desc = "Lazy Plugins", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Thoát Neovim", action = ":qa" },
          },
        },
      },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = { enabled = true },
      words = { enabled = true },
      lazygit = { enabled = true },
    },
    keys = {
      { "<C-\\>", function() Snacks.terminal() end, mode = { "n", "t" }, desc = "Bật/Tắt Terminal (Snacks)" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Mở Lazygit" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Xóa thông báo (Dismiss)" },
      { "jk", [[<C-\><C-n>]], mode = "t", desc = "Thoát Insert trong terminal" },
    },
  },
}
