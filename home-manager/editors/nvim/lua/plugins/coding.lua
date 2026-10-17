return {
  -- Tự động hoàn thành code (Gồm nhiều module bổ trợ đi kèm)
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      {
        "L3MON4D3/LuaSnip", -- Engine snippet cơ bản
        dependencies = { "rafamadriz/friendly-snippets" },
      },
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local vscode_snippets = require("luasnip.loaders.from_vscode")
      vscode_snippets.lazy_load()
      vscode_snippets.lazy_load({
        paths = { vim.fn.stdpath("config") .. "/snippets" },
      })
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        })
      })

      -- nvim-cmp không coi "!" là keyword nên không tự gợi ý snippet.
      -- Map riêng trong buffer tex: "!" ở đầu dòng sẽ chèn boilerplate.
      local function expand_latex_boilerplate()
        if vim.fn.expand("%:e"):lower() ~= "tex" then
          return false
        end

        local before = vim.fn.getline("."):sub(1, vim.fn.col(".") - 1)
        if not before:match("^%s*$") then
          return false
        end

        local luasnip = require("luasnip")
        for _, snip in ipairs(luasnip.get_snippets("tex") or {}) do
          if snip.trigger == "!" then
            luasnip.snip_expand(snip)
            return true
          end
        end
        return false
      end

      local attach_tex_boilerplate = function(buf)
        vim.keymap.set("i", "!", function()
          if not expand_latex_boilerplate() then
            vim.api.nvim_feedkeys("!", "n", false)
          end
        end, { buffer = buf, desc = "Chèn LaTeX boilerplate" })
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "tex",
        callback = function(args) attach_tex_boilerplate(args.buf) end,
      })

      -- nvim-cmp load ở InsertEnter, khi đó FileType của buffer hiện tại đã chạy rồi
      if vim.bo.filetype == "tex" then
        attach_tex_boilerplate(vim.api.nvim_get_current_buf())
      end
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
        mapping = {"jk", "jj"},
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
