return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        current_line_blame = true, -- Hiện tên người code dòng hiện tại (Git blame)
        current_line_blame_opts = {
          delay = 500,
        },
      })
      
      -- Phím tắt nhanh
      local gs = package.loaded.gitsigns
      vim.keymap.set("n", "]h", gs.next_hunk, { desc = "Đến đoạn code sửa tiếp theo (Git)" })
      vim.keymap.set("n", "[h", gs.prev_hunk, { desc = "Về đoạn code sửa trước đó (Git)" })
      vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { desc = "Xem trước đoạn code bị xóa/sửa" })
    end,
  }
}
