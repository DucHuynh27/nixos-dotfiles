# Dalu (Zalo) backup — hướng dẫn sử dụng

Backup tự động dữ liệu Zalo for Linux ra ổ ngoài, có mã hoá.

- **Nguồn**: `~/.config/ZaloData`
- **Đích**: `/mnt/dalu-occac/zalo-backup/`
- **Tên file**: `zalo-YYYYMMDD-HHMMSS.tar.zst.age` (+ `.sha256`)
- **Định dạng**: `tar` → `zstd` → `age` (mã hoá bất đối xứng)
- **Lịch**: mỗi ngày lúc **00:00** (`OnCalendar=daily`, `Persistent=true`)
- **Giữ lại**: 7 bản mới nhất
- **Module config**: `home-manager/system/zalo-backup.nix`
- **Mount ổ**: `nixos/configuration.nix` → `fileSystems."/mnt/dalu-occac"` (sda3, NTFS, UUID `01DD4AB73420D360`)

## Backup gì

Giữ:
`Database/` (tin nhắn, `Media.db`, E2EE, cờ…), `media/` (ảnh/file đính kèm), `ftsm_*.db`,
`Partitions/`, `Local Storage/`, `Session Storage/`, `Cookies`, `TransportSecurity`,
`Network Persistent State`, `linux-offline-session.enc`, `pin-vault-data/`,
`config.json`, `Preferences`, `cal/`, `zcall-devices.json`…

Bỏ (chỉ là cache/ML model, tự sinh lại):
`Cache/`, `Code Cache/`, `GPUCache/`, `DawnCache/`, `resp_cache/`, `tf-models/`,
`Crashpad/`, `blob_storage/`, `Singleton*` (file runtime của Chromium).

> Các file SQLite (`*.db`) đang mở được snapshot bằng `sqlite3 .backup` nên **backup
> chạy được cả khi Zalo đang bật**; không cần tắt app.

## Mã hoá / giải mã

- Recipient (public key) nằm trong `.sops.yaml`, đã bake vào module:
  `age1t4wkm4w9lxlkqtaf9226609lw2raqvsxzac2aq89zhm9553f0fmqaxcjr6`
- Giải mã cần **identity** (private key): `~/.config/sops/age/keys.txt`
- ⚠️ **Mất `~/.config/sops/age/keys.txt` là mất khả năng restore.** File này đã
  được sops quản lý — nhớ giữ nó (và đã có trong `secrets/`).

## Chạy backup

```bash
# chạy tay ngay
systemctl --user start zalo-backup

# xem log
journalctl --user -u zalo-backup -n 50 --no-pager

# trạng thái timer
systemctl --user list-timers zalo-backup.timer
```

Hoặc gọi trực tiếp:

```bash
zalo-backup
```

Nếu `/mnt/dalu-occac` chưa mount, script tự bỏ qua và thoát 0.

## Kiểm tra & liệt kê bản backup

```bash
ls -lh /mnt/dalu-occac/zalo-backup/

# kiểm tra toàn vẹn 1 bản
cd /mnt/dalu-occac/zalo-backup
sha256sum -c zalo-YYYYMMDD-HHMMSS.tar.zst.age.sha256
```

## Restore

### Cách 1 — script (khuyến nghị)

```bash
zalo-restore /mnt/dalu-occac/zalo-backup/zalo-YYYYMMDD-HHMMSS.tar.zst.age
```

Script sẽ: tắt Zalo (nếu đang chạy) → `age -d` → `zstd -d` → `tar -x` vào thư mục tạm
→ dời `~/.config/ZaloData` hiện tại thành `~/.config/ZaloData.bak-<timestamp>`
→ copy dữ liệu đã restore vào chỗ cũ. Xong thì mở lại Zalo.

### Cách 2 — thủ công

```bash
# 1) thoát Zalo
pkill -TERM -f 'zalo-26.11.10-extracted'

# 2) dời dữ liệu hiện tại (đường lui)
mv ~/.config/ZaloData ~/.config/ZaloData.bak-$(date +%F-%H%M%S)
mkdir -p ~/.config/ZaloData

# 3) giải mã + bung
age -d -i ~/.config/sops/age/keys.txt \
  /mnt/dalu-occac/zalo-backup/zalo-YYYYMMDD-HHMMSS.tar.zst.age \
  | zstd -d -T0 \
  | tar -xf - -C ~/.config/ZaloData
```

### Restore lẻ một vài file

```bash
arch=/mnt/dalu-occac/zalo-backup/zalo-YYYYMMDD-HHMMSS.tar.zst.age

# xem danh sách bên trong
age -d -i ~/.config/sops/age/keys.txt "$arch" | zstd -d | tar -tf - | less

# trích ra /tmp/rst chỉ 1 thư mục con
mkdir -p /tmp/rst
age -d -i ~/.config/sops/age/keys.txt "$arch" | zstd -d | tar -xf - -C /tmp/rst ./media
```

Sau restore thường **không cần đăng nhập lại** (đã kèm `Cookies`, `Local Storage`,
`linux-offline-session.enc`, `pin-vault-data/`).

## Tuỳ chỉnh

- **Số bản giữ lại**: sửa `keep` trong `home-manager/system/zalo-backup.nix`
  (mặc định `7`), rồi `home-manager switch`.
- **Giờ chạy**: sửa `systemd.user.timers.zalo-backup.Timer.OnCalendar`
  (`daily` = 00:00; ví dụ `"*-*-* 13:00:00"`).
- **Ổ đích**: đổi `mountPoint`/`fileSystems."/mnt/dalu-occac"` + `device` UUID.
- **Thêm/bớt cache**: sửa list `cacheExcludes` trong module.

## Khắc phục sự cố

| Hiện tượng | Xử lý |
|---|---|
| Timer không chạy | `systemctl --user status zalo-backup.timer`; đảm bảo timer enable: `systemctl --user enable --now zalo-backup.timer` |
| Service bị skip | `/mnt/dalu-occac` chưa mount → `systemctl status mnt-dalu\\x2doccac.mount` |
| `age: error` khi restore | Thiếu/sai identity `~/.config/sops/age/keys.txt` |
| Hết dung lượng ổ đích | Giảm `keep`, hoặc xoá bản cũ trong `/mnt/dalu-occac/zalo-backup/` |
| Backup khi Zalo đang chạy | Bình thường, DB snapshot bằng `sqlite3 .backup` |
