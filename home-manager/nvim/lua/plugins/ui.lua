return {
  -- Màu sắc đồng bộ với Noctalia / Matugen
  {
    "RRethy/base16-nvim",
    priority = 1000,
    config = function()
      -- Thử load file matugen.lua do hệ thống sinh ra
      local ok, _ = pcall(vim.cmd, "colorscheme matugen")
      if not ok then
        vim.cmd("colorscheme default")
      end
    end,
  },

  -- Thanh trạng thái
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Cập nhật thời tiết ngầm (mỗi 30 phút)
      local weather = "Đang tải ☁️"
      local timer = vim.uv.new_timer()
      timer:start(0, 1800000, vim.schedule_wrap(function()
        vim.fn.jobstart({"curl", "-s", "wttr.in/?format=1"}, {
          stdout_buffered = true,
          on_stdout = function(_, data)
            if data and data[1] and data[1] ~= "" and not data[1]:match("Unknown") then
              local text = data[1]:gsub("^%s*(.-)%s*$", "%1")
              text = text:gsub("%s+", " ") -- Thu gọn nhiều khoảng trắng thành 1
              text = text:gsub("%+", "")   -- Xóa dấu + trước nhiệt độ
              weather = text
            end
          end
        })
      end))

      -- Hàm trả về thời tiết
      local function get_weather()
        return weather
      end

      require("lualine").setup({
        options = { theme = "auto" },
        sections = {
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { get_weather, 'location' }
        },
      })
    end,
  },

  -- Tabs (Bufferline)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Tab trước" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Tab tiếp theo" },
      { "<leader>x", "<cmd>bdelete<cr>", desc = "Đóng Tab hiện tại" },
    },
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          always_show_bufferline = true,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              separator = true,
            }
          },
        },
      })
    end,
  },

  -- Cây thư mục (Tạm tắt theo yêu cầu)
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Bật/Tắt Cây thư mục" },
    },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = {
          indent_markers = {
            enable = true,
          },
        },
      })
    end,
  },

  -- Quản lý file cực nhanh kiểu Yazi (Oil)
  {
    "stevearc/oil.nvim",
    dependencies = { 
      "nvim-tree/nvim-web-devicons",
      "malewicz1337/oil-git.nvim",
      "JezerM/oil-lsp-diagnostics.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Oil<cr>", desc = "Mở thư mục hiện tại (Oil)" },
    },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        view_options = {
          show_hidden = true,
        },
      })
    end,
  },

  -- Hiển thị trạng thái Git trong bảng Oil
  {
    "malewicz1337/oil-git.nvim",
    opts = {
      show_file_highlights = true,
      show_directory_highlights = true,
    },
  },

  -- Hiển thị Icon lỗi LSP (Diagnostic) trực tiếp trong bảng Oil
  {
    "JezerM/oil-lsp-diagnostics.nvim",
    opts = {},
  },

  -- Indent Blankline (Thụt lề cầu vồng)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)
      require("ibl").setup({
        indent = { highlight = highlight, char = "│" },
        scope = { enabled = true, show_start = false, show_end = false },
      })
    end,
  },

  -- Giao diện menu nổi xịn xò
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



  -- Cải thiện Quickfix
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },

  -- Highlight và đếm kết quả tìm kiếm
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require("hlslens").setup()
      local kopts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap("n", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap("n", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    end,
  },

  -- Highlight mã màu trực quan (HEX, RGB, CSS, Tailwind)
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
