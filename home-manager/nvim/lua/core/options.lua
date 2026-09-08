local opt = vim.opt

-- Đánh số dòng
opt.number = true
opt.relativenumber = true

-- Tab và thụt lề
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- Giao diện
opt.termguicolors = true
opt.wrap = true
opt.linebreak = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.fillchars = { eob = " " } -- Xóa dấu ~ ở cuối file

-- Tìm kiếm
opt.ignorecase = true
opt.smartcase = true

-- Hệ thống
opt.clipboard = "unnamedplus" -- Copy paste với OS
opt.updatetime = 250
opt.timeoutlen = 300
