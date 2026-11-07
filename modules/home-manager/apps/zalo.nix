# Zalo for Linux (bản port AppImage không chính thức).
# Yêu cầu âm thanh qua PipeWire/PulseAudio (đã bật trong nixos/configuration.nix).
# Lưu ý: mỗi lần rebuild, AppImage cũ bị xoá khỏi Releases -> nếu tải lỗi 404
# thì chạy `nix flake update zalo-for-linux` rồi switch lại.
{lib, ...}: {
  programs.zalo = {
    enable = true;
    # variant = "original"; # AppImage gốc, không kèm ZaDark
    # Chạy mặc định qua XWayland (bản gốc của app); thử ép
    # `commandLineArgs = ["--ozone-platform-hint=wayland"]` nhưng không đỡ lag.
  };

  # App tự ghi/xoá file autostart này; patch ở đây để chắc chắn tắt autostart.
  home.activation.zaloNoAutostart = lib.hm.dag.entryAfter ["writeBoundary"] ''
    rm -f "$HOME/.config/autostart/zalo.desktop"
  '';
}
