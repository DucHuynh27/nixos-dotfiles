# Lưu trữ: mount ổ NTFS data và thư mục Steam library tùy chỉnh.
{...}: {
  # SSD SATA gắn trong (sda3, NTFS) làm nơi backup dữ liệu Zalo.
  # uid/gid/umask: file hiện thuộc user hinne và ghi được; nofail: không chặn
  # boot nếu ổ lỗi/chưa sẵn sàng.
  fileSystems."/mnt/dalu-occac" = {
    device = "/dev/disk/by-uuid/01DD4AB73420D360";
    fsType = "ntfs3";
    options = ["nofail" "x-systemd.device-timeout=10" "uid=1000" "gid=100" "umask=022"];
  };

  # Thư viện Steam cho Wallpaper Engine (Steam không có option Nix để set
  # library path; đây chỉ tạo sẵn thư mục, việc gán library làm trong Steam UI).
  systemd.tmpfiles.rules = [
    "d /home/hinne/Steam 0755 hinne users -"
  ];
}
