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

-- Khắc phục lỗi jdtls / Eclipse bỏ sót trường "result" khi trả về rỗng ({ id = ..., jsonrpc = "2.0" })
local orig_json_decode = vim.json.decode
vim.json.decode = function(s, opts)
	local obj
	if opts ~= nil then
		obj = orig_json_decode(s, opts)
	else
		obj = orig_json_decode(s)
	end
	if
		type(obj) == "table"
		and obj.id
		and obj.id ~= vim.NIL
		and obj.jsonrpc
		and obj.result == nil
		and obj.error == nil
		and obj.method == nil
	then
		obj.result = vim.NIL
	end
	return obj
end

-- Khởi động lazy.nvim và bảo nó tìm các plugin trong thư mục lua/plugins/
require("lazy").setup("plugins", {
	defaults = { lazy = false },
	checker = { enabled = true }, -- Tự động kiểm tra bản cập nhật
})
