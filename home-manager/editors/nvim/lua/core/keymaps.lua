vim.g.mapleader = " " -- Đặt phím leader là phím Space
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- Thoát Insert mode: dùng Esc (không còn mapping jk/jj)

-- Đóng buffer hiện tại (thay cho bufferline đã bỏ)
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Đóng buffer hiện tại" })

map("n", "<leader>nh", ":nohl<CR>", { desc = "Xóa highlight tìm kiếm" })

-- Di chuyển khối dòng trong Visual mode (tương tự Alt+Up/Down)
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Chuyển dòng đã chọn xuống" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Chuyển dòng đã chọn lên" })

-- Giữ vùng chọn sau khi thụt lề
map("v", "<", "<gv", { desc = "Thụt lề sang trái" })
map("v", ">", ">gv", { desc = "Thụt lề sang phải" })
