return {
  {
    "ibhagwan/fzf-lua",
    cmd = { "FzfLua" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Tìm file" },
      { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Tìm chữ trong file" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Tìm buffer" },
    },
    config = function()
      require("fzf-lua").setup({})
    end,
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Nhảy chuột (Flash)" },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup()
      local is_tex = function() return vim.bo.filetype == "tex" end
      wk.add({
        { "<leader>f", group = "Tìm kiếm (Find)" },
        { "<leader>s", group = "Cửa sổ (Splits)" },
        { "<leader>u", group = "Giao diện (UI)" },
        { "<leader>n", group = "Tiện ích (Misc)" },
        { "<leader>c", group = "Code (LSP)" },
        { "<leader>d", group = "Săn lỗi (Diagnostics)" },
        { "<leader>g", group = "Git" },
        { "<leader>q", group = "Phiên làm việc (Session)" },
        { "<leader>x", group = "Bảng lỗi (Trouble)" },
        { "<localleader>l", group = "LaTeX (VimTeX)", cond = is_tex },
        { "<localleader>ll", desc = "Biên dịch (latexmk + xelatex)", cond = is_tex },
        { "<localleader>lS", desc = "Biên dịch một lần", cond = is_tex },
        { "<localleader>lv", desc = "Xem PDF (Zathura + SyncTeX)", cond = is_tex },
        { "<localleader>lk", desc = "Dừng biên dịch", cond = is_tex },
        { "<localleader>le", desc = "Danh sách lỗi", cond = is_tex },
        { "<localleader>lq", desc = "Xem log biên dịch", cond = is_tex },
        { "<localleader>lo", desc = "Xem output biên dịch", cond = is_tex },
        { "<localleader>lc", desc = "Xóa file phụ", cond = is_tex },
        { "<localleader>lC", desc = "Xóa toàn bộ file sinh ra", cond = is_tex },
        { "<localleader>lt", desc = "Mở mục lục", cond = is_tex },
        { "<localleader>lT", desc = "Bật/tắt mục lục", cond = is_tex },
        { "<localleader>li", desc = "Thông tin project", cond = is_tex },
        { "<localleader>ls", desc = "Chọn file main", cond = is_tex },
        { "<localleader>lm", desc = "Danh sách imaps", cond = is_tex },
        { "<localleader>la", desc = "Context menu VimTeX", cond = is_tex },
        { "<localleader>lX", desc = "Reload VimTeX state", cond = is_tex },
      })
    end,
  },

  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    keys = {
      { "<leader>a", "<cmd>AerialToggle!<CR>", desc = "Bật/Tắt Cấu trúc code" },
    },
    config = function()
      require("aerial").setup()
    end,
  },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufRead",
    config = function()
      vim.o.foldcolumn = "0"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end
      })
    end,
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Khôi phục Session hiện tại" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Khôi phục Session gần nhất" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Không lưu Session khi thoát" },
    },
  },

  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Bảng lỗi Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Lỗi trong file hiện tại" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Cấu trúc Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / References (Trouble)" },
    },
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Mở LazyGit toàn màn hình" },
    },
  },
}
