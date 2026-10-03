return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")

      conform.setup({
        notify_on_error = false,
        formatters_by_ft = {
          javascript = { "prettierd", "prettier", stop_after_first = true },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          javascriptreact = { "prettierd", "prettier", stop_after_first = true },
          typescriptreact = { "prettierd", "prettier", stop_after_first = true },
          css = { "prettierd", "prettier", stop_after_first = true },
          html = { "prettierd", "prettier", stop_after_first = true },
          json = { "prettierd", "prettier", stop_after_first = true },
          yaml = { "prettierd", "prettier", stop_after_first = true },
          markdown = { "prettierd", "prettier", stop_after_first = true },
          lua = { "stylua" },
          nix = { "alejandra" },
          python = { "isort", "black" },
        },
        format_on_save = {
          lsp_format = "fallback",
          async = false,
          timeout_ms = 3000,
        },
      })

      -- Phím tắt để format thủ công
      vim.keymap.set({ "n", "v" }, "<leader>fm", function()
        conform.format({
          lsp_format = "fallback",
          async = false,
          timeout_ms = 3000,
        })
      end, { desc = "Format file hiện tại" })
    end,
  }
}
