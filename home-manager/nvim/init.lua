-- Nạp các cài đặt cơ bản
require("core.options")
require("core.keymaps")

-- Bootstrap lazy.nvim (Tự động tải về nếu chưa có)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Chỉ dùng bản ổn định mới nhất
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Khởi động lazy.nvim và bảo nó tìm các plugin trong thư mục lua/plugins/
require("lazy").setup("plugins", {
  defaults = { lazy = false },
  checker = { enabled = true }, -- Tự động kiểm tra bản cập nhật
})
