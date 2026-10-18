{...}: {
  programs.zathura = {
    enable = true;
    # Giữ nguyên màu nền tài liệu gốc (giấy trắng), chỉ theme phần UI
    options.recolor = false;
  };
}
