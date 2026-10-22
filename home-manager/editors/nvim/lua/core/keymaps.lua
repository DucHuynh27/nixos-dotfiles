vim.g.mapleader = " " -- Đặt phím leader là phím Space
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- Thoát Insert mode do better-escape.nvim lo (lua/plugins/coding.lua)

-- Đóng buffer hiện tại (thay cho bufferline đã bỏ)
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Đóng buffer hiện tại" })

-- Quản lý cửa sổ (Split window)
map("n", "<leader>sv", "<C-w>v", { desc = "Chia dọc màn hình" })
map("n", "<leader>sh", "<C-w>s", { desc = "Chia ngang màn hình" })
map("n", "<leader>se", "<C-w>=", { desc = "Làm đều các cửa sổ" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Đóng cửa sổ hiện tại" })

-- Xóa highlight tìm kiếm
map("n", "<leader>nh", ":nohl<CR>", { desc = "Xóa highlight tìm kiếm" })

-- Di chuyển khối dòng trong Visual mode (tương tự Alt+Up/Down)
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Chuyển dòng đã chọn xuống" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Chuyển dòng đã chọn lên" })

-- Giữ vùng chọn sau khi thụt lề
map("v", "<", "<gv", { desc = "Thụt lề sang trái" })
map("v", ">", ">gv", { desc = "Thụt lề sang phải" })
