return {
  -- Cấu hình LSP (Language Server Protocol)
  {
    "neovim/nvim-lspconfig",
    version = "*", -- Khóa ở phiên bản ổn định (Stable) để tránh cảnh báo từ nhánh Master
    config = function()
      require("lspconfig") -- Đảm bảo plugin load các template LSP
      -- Dùng capabilities mặc định của Neovim (đã có snippetSupport/resolveSupport/
      -- insertReplaceSupport). Không gọi require("blink.cmp") ở đây, vì làm vậy
      -- blink sẽ load ngay lúc khởi động (~15ms) thay vì đợi InsertEnter.
      local capabilities = vim.lsp.protocol.make_client_capabilities()

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
      setup_server("ts_ls")       -- JS/TS (typescript-language-server)
      setup_server("eslint")      -- Linter chuẩn cho JS/TS & React
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
      setup_server("texlab", {    -- LaTeX (build bằng xelatex)
        settings = {
          texlab = {
            build = {
              executable = "latexmk",
              args = {
                "-xelatex",
                "-interaction=nonstopmode",
                "-synctex=1",
                "%f",
              },
            },
          },
        },
      })

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
      vim.keymap.set("n", "<leader>dd", function() require("fzf-lua").diagnostics_document() end, { desc = "Danh sách lỗi trong file" })

      -- Phím tắt điều hướng & thao tác Code (LSP)
      vim.keymap.set("n", "gd", function() require("fzf-lua").lsp_definitions() end, { desc = "Đến định nghĩa (Definition)" })
      vim.keymap.set("n", "gr", function() require("fzf-lua").lsp_references() end, { desc = "Tìm các nơi sử dụng (References)" })
      vim.keymap.set("n", "gI", function() require("fzf-lua").lsp_implementations() end, { desc = "Đến Implementation" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Xem tài liệu hàm (Hover)" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Hành động code (Code Action)" })
      -- <leader>cr (đổi tên) nằm trong lua/plugins/qol.lua (inc-rename)
    end,
  },
  
}
