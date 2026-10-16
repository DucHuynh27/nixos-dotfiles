local opt = vim.opt

-- Đánh số dòng
opt.number = true
opt.relativenumber = true

-- Tab và thụt lề
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Tự động đổi sang Tab 4 đối với các ngôn ngữ có tính chất dài hoặc bắt buộc
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "java", "c", "cpp", "cs", "rust" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Giao diện
opt.termguicolors = true
opt.wrap = true
opt.linebreak = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8 -- Giữ khoảng đệm 8 dòng khi cuộn
opt.fillchars = { 
  eob = " ", -- Xóa dấu ~ ở cuối file
  fold = " ", 
  foldopen = "", 
  foldsep = "│", 
  foldclose = "" 
}

-- Tìm kiếm
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split" -- Xem trước thay thế chuỗi theo thời gian thực

-- Hệ thống
opt.clipboard = "unnamedplus" -- Copy paste với OS
opt.undofile = true -- Lưu lịch sử hoàn tác (Undo) vĩnh viễn
opt.splitbelow = true -- Mở cửa sổ chia ngang ở dưới
opt.splitright = true -- Mở cửa sổ chia dọc ở bên phải
opt.updatetime = 250
opt.timeoutlen = 300
