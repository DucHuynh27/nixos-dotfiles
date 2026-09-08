-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.expandtab = true   -- Tự động chuyển đổi ký tự Tab thực thành các khoảng trắng (Spaces)
vim.opt.tabstop = 4        -- Độ rộng hiển thị của 1 ký tự Tab thực sự (bằng 4 khoảng trắng)
vim.opt.shiftwidth = 4     -- Số khoảng trắng được thụt lề khi dùng các phím > hoặc <
vim.opt.softtabstop = 4    -- Số khoảng trắng tương đương với 1 lần nhấn Tab khi gõ

-- Cho phép Prettier format mà không cần file cấu hình (.prettierrc) trong dự án
vim.g.lazyvim_prettier_needs_config = false

vim.opt.wrap = true -- Bật chế độ tự động xuống dòng (word wrap)
