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

  -- Nhảy chuột nhanh
  {
    "smoka7/hop.nvim",
    keys = {
      { "s", "<cmd>HopChar2<cr>", desc = "Nhảy đến ký tự" },
    },
    config = function()
      require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
    end,
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
        { "<leader>g", group = "Git" },
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
      vim.o.foldcolumn = "1"
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
}
