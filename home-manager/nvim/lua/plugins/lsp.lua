return {
  -- Cấu hình LSP (Language Server Protocol)
  {
    "neovim/nvim-lspconfig",
    version = "*", -- Khóa ở phiên bản ổn định (Stable) để tránh cảnh báo từ nhánh Master
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- Giao tiếp với nvim-cmp
    },
    config = function()
      require("lspconfig") -- Đảm bảo plugin load các template LSP
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Hàm rút gọn để setup LSP chuẩn Neovim 0.11+
      local setup_server = function(server_name, custom_opts)
        local opts = custom_opts or {}
        opts.capabilities = capabilities
        if vim.lsp.config then
          vim.lsp.config(server_name, opts)
          vim.lsp.enable(server_name)
        else
          require("lspconfig")[server_name].setup(opts)
        end
      end

      -- Kích hoạt các LSP cho Full Stack JS & DevOps
      setup_server("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } }
      })
      -- Đã gỡ ts_ls vì sẽ dùng typescript-tools.nvim ở dưới
      setup_server("html")        -- HTML
      setup_server("cssls")       -- CSS
      setup_server("tailwindcss") -- Tailwind
      setup_server("yamlls")      -- YAML
      setup_server("jsonls")      -- JSON
      setup_server("dockerls")    -- Docker
      setup_server("bashls")      -- Bash
      setup_server("nil_ls")      -- Nix
      setup_server("pyright")     -- Python
      setup_server("ruff")        -- Linter siêu tốc cho Python

      -- Cấu hình hiển thị Icon chẩn đoán (Diagnostics)
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '✘',
            [vim.diagnostic.severity.WARN] = '⚠',
            [vim.diagnostic.severity.INFO] = 'ℹ',
            [vim.diagnostic.severity.HINT] = '💡',
          },
        },
      })

      -- Phím tắt Báo lỗi (Diagnostics)
      vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Xem chi tiết lỗi (Float)" })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Lỗi trước đó" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Lỗi tiếp theo" })
      vim.keymap.set("n", "<leader>dd", "<cmd>FzfLua diagnostics_document<cr>", { desc = "Danh sách lỗi trong file" })
    end,
  },
  
  -- Vũ khí bí mật cho Java
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },

  -- Vũ khí bí mật cho JS/TS (Thay thế hoàn toàn ts_ls)
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  }
}
