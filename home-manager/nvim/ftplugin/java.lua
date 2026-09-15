local config = {
  cmd = { 'jdtls' },
  root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]) or vim.fn.getcwd(),
}

require('jdtls').start_or_attach(config)

-- Phím tắt siêu năng lực của riêng Java
local map = vim.keymap.set
map("n", "<leader>jo", "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = "Tự động gỡ/thêm thư viện Import (Java)" })
map("n", "<leader>jv", "<Cmd>lua require('jdtls').extract_variable()<CR>", { desc = "Gói thành biến (Java)" })
map("n", "<leader>jc", "<Cmd>lua require('jdtls').extract_constant()<CR>", { desc = "Gói thành hằng số (Java)" })
map("v", "<leader>jm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", { desc = "Gói khối lệnh thành Hàm (Java)" })
