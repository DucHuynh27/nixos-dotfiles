-- Tiện ích nhỏ, đều lazy-load nên không tốn thời gian khởi động.
return {
  -- Comment đúng cú pháp theo ngữ cảnh (sửa `gc` trong JSX/TSX)
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Đổi tên có xem trước trực tiếp thay vì hộp thoại cmdline khô khan
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = {
      {
        "<leader>cr",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        expr = true,
        desc = "Đổi tên biến/hàm (xem trước trực tiếp)",
      },
    },
    opts = {},
  },

  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "<leader>ft", "<cmd>TodoFzfLua<cr>", desc = "TODO/FIXME trong project" },
    },
  },

  -- Tiến trình LSP (index, format...) ở góc dưới phải
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
