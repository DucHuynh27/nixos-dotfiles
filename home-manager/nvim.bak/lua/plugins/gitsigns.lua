return {
  "lewis6991/gitsigns.nvim",
  opts = {
    attach_to_untracked = true, -- Ép hiển thị dấu thay đổi (+) cho cả file mới chưa git add
    current_line_blame = true,  -- Bật tính năng hiển thị Git Blame (giống GitLens của VSCode) ở cuối dòng code
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", 
      delay = 500, -- Đợi 0.5 giây sau khi dừng gõ thì mới hiện chữ mờ để đỡ rối mắt
    },
  },
}
