return {
  -- Chạy lệnh bất đồng bộ
  {
    "skywind3000/asyncrun.vim",
    cmd = { "AsyncRun" },
  },

  -- Terminal tích hợp (VSCode style)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Mở Terminal (VSCode style)" },
    },
    config = function()
      require("toggleterm").setup({
        size = 15,
        open_mapping = [[<C-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true,
      })
      
      -- Tắt số dòng khi ở trong Terminal
      vim.cmd("autocmd! TermOpen term://* setlocal nonumber norelativenumber")
      -- Mappings để đóng hoặc thoát Insert mode trong Terminal
      vim.keymap.set('t', '<C-\\>', [[<C-\><C-n><cmd>ToggleTerm<CR>]], { desc = "Đóng Terminal" })
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], { desc = "Thoát Insert mode" })
    end,
  },
}
