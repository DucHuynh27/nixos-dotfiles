return {
	-- Màu sắc động theo Noctalia (Base16)
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			-- Palette do Noctalia sinh ra ở lua/matugen.lua (template "Neovim"),
			-- ghi lại mỗi khi đổi theme. Không hardcode màu ở đây.
			local ok, matugen = pcall(require, "matugen")
			if ok then
				matugen.setup()
			else
				-- Noctalia chưa sinh palette lần nào: dùng tạm base16 mặc định.
				vim.cmd.colorscheme("base16-default-dark")
			end
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- Cập nhật thời tiết ngầm (mỗi 30 phút)
			local weather = "Đang tải ☁️"
			local timer = vim.uv.new_timer()
			timer:start(
				0,
				1800000,
				vim.schedule_wrap(function()
					vim.fn.jobstart({ "curl", "-s", "wttr.in/?format=1" }, {
						stdout_buffered = true,
						on_stdout = function(_, data)
							if data and data[1] and data[1] ~= "" and not data[1]:match("Unknown") then
								local text = data[1]:gsub("^%s*(.-)%s*$", "%1")
								text = text:gsub("%s+", " ") -- Thu gọn nhiều khoảng trắng thành 1
								text = text:gsub("%+", "") -- Xóa dấu + trước nhiệt độ
								weather = text
							end
						end,
					})
				end)
			)

			local function get_weather()
				return weather
			end

			require("lualine").setup({
				options = { theme = "auto" },
				sections = {
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { get_weather, "location" },
				},
			})
		end,
	},

	-- Breadcrumb trên winbar (thay bufferline: không cần thanh tab nữa)
	{
		"Bekaboo/dropbar.nvim",
		event = "VeryLazy",
		config = function()
			local sources = require("dropbar.sources")
			local utils = require("dropbar.utils")
			require("dropbar").setup({
				bar = {
					update_debounce = 32,
					sources = function(buf)
						if vim.bo[buf].buftype == "terminal" then
							return { sources.terminal }
						end
						if vim.bo[buf].ft == "markdown" then
							return { sources.markdown }
						end
						-- Không dùng sources.path: tên file đã nằm trên statusline (lualine)
						return { utils.source.fallback({ sources.lsp, sources.treesitter }) }
					end,
				},
			})
		end,
	},

	{
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{
				"<leader>e",
				function()
					require("yazi").yazi()
				end,
				desc = "Mở Yazi",
			},
			{
				"<leader>E",
				function()
					require("yazi").toggle()
				end,
				desc = "Mở Yazi gần nhất",
			},
		},
		opts = {
			open_for_directories = true,
			floating_window_scaling_factor = 0.9,
			yazi_floating_window_border = "rounded",
			integrations = {
				grep_in_selected_files = true,
			},
		},
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			-- 4 màu do lua/matugen.lua định nghĩa từ palette Noctalia (M3 chỉ có 4 hue)
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowViolet",
			}

			-- Fallback nếu template Noctalia chưa sinh các group Rainbow*.
			local function ensure_rainbow(name, link)
				if next(vim.api.nvim_get_hl(0, { name = name })) == nil then
					vim.api.nvim_set_hl(0, name, { link = link })
				end
			end
			ensure_rainbow("RainbowRed", "DiagnosticError")
			ensure_rainbow("RainbowYellow", "DiagnosticWarn")
			ensure_rainbow("RainbowBlue", "DiagnosticInfo")
			ensure_rainbow("RainbowViolet", "DiagnosticHint")

			require("ibl").setup({
				indent = { highlight = highlight, char = "│" },
				scope = { enabled = true, show_start = false, show_end = false },
			})
		end,
	},

	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		config = function()
			require("dressing").setup({
				select = {
					-- Ép dùng giao diện nổi của chính Dressing thay vì xài ké Fzf-lua
					backend = { "builtin" },
					builtin = {
						border = "rounded",
						relative = "cursor",
					},
				},
			})
		end,
	},

	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
	},

	{
		"kevinhwang91/nvim-hlslens",
		config = function()
			require("hlslens").setup()
			local kopts = { noremap = true, silent = true }
			vim.api.nvim_set_keymap(
				"n",
				"n",
				[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
				kopts
			)
			vim.api.nvim_set_keymap(
				"n",
				"N",
				[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
				kopts
			)
			vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
		end,
	},

	{
		"brenoprata10/nvim-highlight-colors",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			render = "background", -- 'background' | 'foreground' | 'virtual'
			enable_named_colors = true,
			enable_tailwind = true,
		},
	},
}
