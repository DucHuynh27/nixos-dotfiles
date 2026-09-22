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

-- Khắc phục lỗi tương thích Neovim 0.12+ với nvim-treesitter (directives & predicates trả về TSNode[] thay vì TSNode đơn)
if vim.fn.has("nvim-0.12") == 1 then
  local orig_add_directive = vim.treesitter.query.add_directive
  vim.treesitter.query.add_directive = function(name, handler, opts)
    local wrapped_handler = function(match, pattern, bufnr, pred, metadata)
      local unwrapped = setmetatable({}, {
        __index = function(_, k)
          local v = match[k]
          if type(v) == "table" and v[1] and type(v[1]) == "userdata" then
            return v[#v]
          end
          return v
        end,
      })
      return handler(unwrapped, pattern, bufnr, pred, metadata)
    end
    return orig_add_directive(name, wrapped_handler, opts)
  end

  local orig_add_predicate = vim.treesitter.query.add_predicate
  vim.treesitter.query.add_predicate = function(name, handler, opts)
    local wrapped_handler = function(match, pattern, bufnr, pred)
      local unwrapped = setmetatable({}, {
        __index = function(_, k)
          local v = match[k]
          if type(v) == "table" and v[1] and type(v[1]) == "userdata" then
            return v[#v]
          end
          return v
        end,
      })
      return handler(unwrapped, pattern, bufnr, pred)
    end
    return orig_add_predicate(name, wrapped_handler, opts)
  end
end

-- Khắc phục lỗi jdtls / Eclipse bỏ sót trường "result" khi trả về rỗng ({ id = ..., jsonrpc = "2.0" })
local orig_json_decode = vim.json.decode
vim.json.decode = function(s, opts)
  local obj
  if opts ~= nil then
    obj = orig_json_decode(s, opts)
  else
    obj = orig_json_decode(s)
  end
  if type(obj) == "table" and obj.id and obj.id ~= vim.NIL and obj.jsonrpc and obj.result == nil and obj.error == nil and obj.method == nil then
    obj.result = vim.NIL
  end
  return obj
end

-- Khởi động lazy.nvim và bảo nó tìm các plugin trong thư mục lua/plugins/
require("lazy").setup("plugins", {
  defaults = { lazy = false },
  checker = { enabled = true }, -- Tự động kiểm tra bản cập nhật
})
