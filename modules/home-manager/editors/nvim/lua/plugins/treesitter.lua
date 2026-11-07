return {
  {
    -- Nhánh "main" là bản viết lại cho Neovim 0.12+; "master" đã khóa và
    -- gây lỗi "attempt to call method 'range' (a nil value)" khi mở markdown
    -- có fenced code block.
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      ts.install({
        "bash",
        "c",
        "cpp",
        "css",
        "diff",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "html",
        "java",
        "javascript",
        "json",
        "latex",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "nix",
        "python",
        "query",
        "regex",
        "rust",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      })

      -- Neovim 0.12 tự lo highlight/indent, nvim-treesitter chỉ cung cấp parser + query
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          if pcall(vim.treesitter.start) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      mode = "cursor",
      max_lines = 3,
    },
  },
}
