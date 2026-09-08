return {
  -- Màu sắc đồng bộ với Noctalia / Matugen
  {
    "RRethy/base16-nvim",
    priority = 1000,
    config = function()
      -- Thử load file matugen.lua do hệ thống sinh ra
      local ok, _ = pcall(vim.cmd, "colorscheme matugen")
      if not ok then
        vim.cmd("colorscheme default")
      end
    end,
  },

  -- Thanh trạng thái
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "auto" },
      })
    end,
  },

  -- Cây thư mục
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Bật/Tắt Cây thư mục" },
    },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = {
          indent_markers = {
            enable = true,
          },
        },
      })
    end,
  },

  -- Thông báo đẹp
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      background_colour = "#000000",
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },

  -- Cải thiện Quickfix
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },

  -- Highlight và đếm kết quả tìm kiếm
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require("hlslens").setup()
      local kopts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap("n", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap("n", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    end,
  },
}
