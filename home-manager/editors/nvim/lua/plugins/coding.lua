return {
  -- Tự động hoàn thành code (blink.cmp v1 - bản ổn định, không theo nhánh main)
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip", -- Engine snippet
        dependencies = { "rafamadriz/friendly-snippets" },
      },
    },
    opts = {
      keymap = { preset = "enter" }, -- <CR> nhận, <Tab>/<S-Tab> chọn
      snippets = { preset = "luasnip" }, -- Dùng chung registry với LuaSnip
      appearance = { nerd_font_variant = "mono" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      completion = { documentation = { auto_show = true, auto_show_delay_ms = 300 } },
    },
    config = function(_, opts)
      -- Nạp snippet của friendly-snippets vào LuaSnip
      require("luasnip.loaders.from_vscode").lazy_load()
      require("blink.cmp").setup(opts)
    end,
  },

  -- Tự động đóng ngoặc
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- Quản lý ngoặc (Surround)
  {
    "machakann/vim-sandwich",
    event = "BufRead",
  },

  -- Thoát insert mode cực nhanh (jk)
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup({
        mapping = { "jk", "jj" },
      })
    end,
  },

  -- Hiển thị Markdown đẹp mắt
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("render-markdown").setup({})
    end,
  },
}
