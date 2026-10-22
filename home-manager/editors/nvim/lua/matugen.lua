-- Màu động: nguồn duy nhất là Noctalia.
-- Noctalia ghi lại ~/.config/noctalia/colors.json mỗi khi đổi theme/wallpaper,
-- rồi chạy `pkill -USR1 nvim` (xem desktop-shell/noctalia/settings.json).
-- Không hardcode palette ở bất kỳ file nào khác.
local M = {}

local palette_path = vim.fn.expand("~/.config/noctalia/colors.json")

-- Chỉ dùng khi file của Noctalia chưa tồn tại (lần chạy đầu, máy mới).
local fallback = {
	mError = "#e78284",
	mHover = "#8caaee",
	mOnError = "#232634",
	mOnHover = "#232634",
	mOnPrimary = "#232634",
	mOnSecondary = "#232634",
	mOnSurface = "#c6d0f5",
	mOnSurfaceVariant = "#a5adce",
	mOnTertiary = "#232634",
	mOutline = "#626880",
	mPrimary = "#8caaee",
	mSecondary = "#f4b8e4",
	mShadow = "#232634",
	mSurface = "#303446",
	mSurfaceVariant = "#414559",
	mTertiary = "#ca9ee6",
}

-- Đọc palette hiện tại của Noctalia (16 role Material 3)
function M.palette()
	local fd = io.open(palette_path, "r")
	if not fd then
		return fallback
	end
	local raw = fd:read("*a")
	fd:close()

	local ok, data = pcall(vim.json.decode, raw)
	if ok and type(data) == "table" and data.mSurface then
		return data
	end
	return fallback
end

-- M3 không có green/cyan riêng nên chỉ có 4 hue dùng được.
-- Bảng quy đổi dưới đây là chỗ DUY NHẤT cần sửa khi muốn đổi cách map màu.
local function to_base16(c)
	return {
		base00 = c.mSurface,
		base01 = c.mSurfaceVariant,
		base02 = c.mSurfaceVariant,
		base03 = c.mOutline,
		base04 = c.mOnSurfaceVariant,
		base05 = c.mOnSurface,
		base06 = c.mOnSurface,
		base07 = c.mOnSurface,
		base08 = c.mError,
		base09 = c.mTertiary,
		base0A = c.mSecondary,
		base0B = c.mPrimary,
		base0C = c.mTertiary,
		base0D = c.mPrimary,
		base0E = c.mTertiary,
		base0F = c.mError,
	}
end

local function apply()
	local c = M.palette()
	M.colors = c

	require("base16-colorscheme").setup(to_base16(c))
	vim.g.colors_name = "base16"

	local hi = vim.api.nvim_set_hl

	-- Comment thường (file không có treesitter) cũng nghiêng để terminal map italic -> Radon
	hi(0, "Comment", { fg = c.mOutline, italic = true })

	-- Giao diện chọn (fzf-lua) dùng đúng palette, thay vì màu mặc định của nvim
	hi(0, "FzfLuaNormal", { fg = c.mOnSurface, bg = c.mSurface })
	hi(0, "FzfLuaBorder", { fg = c.mOutline, bg = c.mSurface })
	hi(0, "FzfLuaTitle", { fg = c.mSurface, bg = c.mPrimary, bold = true })
	hi(0, "FzfLuaTitleFlags", { fg = c.mSurface, bg = c.mOnSurfaceVariant })
	hi(0, "FzfLuaCursorLine", { bg = c.mSurfaceVariant })
	hi(0, "FzfLuaSearch", { fg = c.mSurface, bg = c.mPrimary, bold = true })

	-- which-key
	hi(0, "WhichKeyFloat", { bg = c.mSurface })
	hi(0, "WhichKeyBorder", { fg = c.mOutline, bg = c.mSurface })
	hi(0, "WhichKeyGroup", { fg = c.mPrimary })
	hi(0, "WhichKeyDesc", { fg = c.mOnSurface })
	hi(0, "WhichKeySeparator", { fg = c.mOutline })

	-- dropbar (breadcrumb trên winbar + menu)
	hi(0, "DropBarIconUISeparator", { fg = c.mOutline })
	hi(0, "DropBarMenuFloatBorder", { fg = c.mOutline, bg = c.mSurface })

	-- Thụt lề cầu vồng: 4 màu, ibl tự lặp lại theo độ sâu
	hi(0, "RainbowRed", { fg = c.mError })
	hi(0, "RainbowYellow", { fg = c.mSecondary })
	hi(0, "RainbowBlue", { fg = c.mPrimary })
	hi(0, "RainbowViolet", { fg = c.mTertiary })
end

function M.setup()
	apply()

	-- Noctalia gửi SIGUSR1 sau khi đổi màu: đọc lại file rồi áp dụng lại.
	if _G.__matugen_signal then
		_G.__matugen_signal:stop()
		_G.__matugen_signal:close()
	end

	local signal = vim.uv.new_signal()
	_G.__matugen_signal = signal
	signal:start(
		"sigusr1",
		vim.schedule_wrap(function()
			package.loaded["matugen"] = nil
			require("matugen").setup()
		end)
	)
end

return M
