vim.g.mapleader = " " -- Đặt phím leader là phím Space
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- Thoát insert mode nhanh bằng jk (có thể dùng better-escape.vim sau)
map("i", "jk", "<ESC>", { desc = "Thoát Insert mode" })

-- Quản lý cửa sổ (Split window)
map("n", "<leader>sv", "<C-w>v", { desc = "Chia dọc màn hình" })
map("n", "<leader>sh", "<C-w>s", { desc = "Chia ngang màn hình" })
map("n", "<leader>se", "<C-w>=", { desc = "Làm đều các cửa sổ" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Đóng cửa sổ hiện tại" })

-- Xóa highlight tìm kiếm
map("n", "<leader>nh", ":nohl<CR>", { desc = "Xóa highlight tìm kiếm" })
