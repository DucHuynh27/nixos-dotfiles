return {
  -- Tìm kiếm siêu tốc
  {
    "ibhagwan/fzf-lua",
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

  -- Nhảy chuột nhanh (Flash thế hệ mới)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Nhảy chuột (Flash)" },
    },
  },

  -- Menu phím tắt
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup()
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
      })
    end,
  },

  -- Outline cấu trúc code
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

  -- Gấp code nâng cao
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

  -- Quản lý và khôi phục phiên làm việc (Session)
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

  -- Bảng quản lý lỗi tập trung toàn dự án (Trouble)
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

  -- Quản lý Git trực quan với LazyGit
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
