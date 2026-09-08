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
      setup_server("ts_ls")       -- JS/TS (Tên mới của tsserver)
      setup_server("html")        -- HTML
      setup_server("cssls")       -- CSS
      setup_server("tailwindcss") -- Tailwind
      setup_server("yamlls")      -- YAML
      setup_server("jsonls")      -- JSON
      setup_server("dockerls")    -- Docker
      setup_server("bashls")      -- Bash
      setup_server("nil_ls")      -- Nix
      setup_server("pyright")     -- Python
      setup_server("jdtls")       -- Java
    end,
  },
}
