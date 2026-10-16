return {
	{
		"lervag/vimtex",
		lazy = false, -- Tác giả VimTeX khuyên không nên lazy-load để tránh mất hook tự động
		init = function()
			-- Dùng Zathura làm trình đọc PDF (hỗ trợ SyncTeX 2 chiều)
			vim.g.vimtex_view_method = "zathura"

			-- Dùng latexmk để tự động biên dịch ngầm
			vim.g.vimtex_compiler_method = "latexmk"

			-- Chỉ mở cửa sổ thông báo khi có lỗi thật (bỏ qua các cảnh báo Warning không quan trọng)
			vim.g.vimtex_quickfix_mode = 0

			-- Build
			vim.g.vimtex_compiler_latexmk = {
				build_dir = "",
				output_dir = "",
				callback = 1,
				continuos = 1, -- tự biên dịch lại nếu có thay đổi
				executable = "latexmk",
				options = {
					"-verbose",
					"-file-line-error",
					"-synctex = 1",
					"-interaction = nonstopmode,",
				},
			}
			-- Ẩn bớt các file rác sinh ra trong quá trình compile (.aux, .log, .out...)
			vim.g.vimtex_compiler_clean_paths = {
				"*.aux",
				"*.bbl",
				"*.bcf",
				"*.blg",
				"*.fdb_latexmk",
				"*.fls",
				"*.log",
				"*.out",
				"*.run.xml",
				"*.synctex.gz",
				"*.toc",
			}
		end,
	},
}
