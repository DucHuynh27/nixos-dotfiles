# NixOS & Home Manager Configuration

Hệ thống gồm hai phần:

- **NixOS (`nixosConfigurations.nixos`)**: Quản lý kernel, driver, bootloader và các dịch vụ cấp hệ thống.
- **Home Manager (`homeConfigurations."hinne@nixos"`)**: Quản lý dotfiles, terminal, CLI tools và apps.

## Cấu trúc thư mục

```text
~/nix-config/
    ├── flake.nix
    ├── flake.lock
    ├── .sops.yaml
    │
    ├── hosts/                     # Cấu hình cho từng máy
    │   └── nixos/
    │       ├── configuration.nix
    │       ├── hardware-configuration.nix
    │       └── nitro-linux.nix        # Kernel module + service
    │
    ├── modules/
    │   ├── nixos/                     # Cấu hình hệ thống cấp root
    │   │   ├── base.nix               # Bootloader, kernel, timezone, nix, networkmanager
    │   │   ├── security.nix           # Polkit, rtkit, firewall, tailscale
    │   │   ├── virtualization.nix     # Podman, waydroid, libvirt
    │   │   ├── desktop.nix            # XDG portal, fonts, bluetooth, games
    │   │   └── hardware/
    │   │       ├── nvidia.nix
    │   │       ├── audio.nix
    │   │       └── storage.nix
    │   │
    │   └── home-manager/              # Cấu hình người dùng
    │       ├── home.nix               # Orchestrator + home.packages
    │       ├── dev/                   # languages.nix, lsp.nix
    │       ├── apps/
    │       ├── colorscheme/
    │       ├── desktop-shell/
    │       ├── editors/
    │       ├── system/
    │       ├── tui/
    │       └── wm/
    │
    ├── packages/                      # Package tự đóng gói
    │   └── nitro-linux.nix
    │
    └── secrets/                       # Dữ liệu mã hóa bằng SOPS (Age)
        └── secrets.yaml
```

---

## 1. Cho máy NixOS mới

### Bước 1.1: Phục hồi SOPS Key

Tạo thư mục và chép file `keys.txt` từ USB lưu trữ của bạn vào đúng vị trí cũ:

```bash
mkdir -p ~/.config/sops/age
# Chép file keys.txt vào thư mục trên
# Phân quyền bảo mật chặt chẽ cho file key:
chmod 600 ~/.config/sops/age/keys.txt
```

### Bước 1.2: Clone dotfile

Sử dụng môi trường tạm thời của Nix để gọi Git và tải repo về:

```bash
nix-shell -p git
git clone https://github.com/DucHuynh27/nixos-dotfiles.git ~/nix-config
cd ~/nix-config
```

### Bước 1.3: Rebuild OS

_Lưu ý: Hãy tạo lại file hardware-configuration trước._

```bash
# (Tuỳ chọn) Tạo file hardware-configuration.nix cho máy mới:
# sudo nixos-generate-config --show-hardware-config > hosts/nixos/hardware-configuration.nix

# Áp dụng cấu hình NixOS:
sudo nixos-rebuild switch --flake .#nixos
# Hoặc dùng nh:
# nh os switch
```

### Bước 1.4: Rebuild Home Manager

Dùng `nh` đã được cài đặt ở Bước 1.3, chỉ cần:

```bash
nh home switch
```

Sau khi lệnh chạy xong, khởi động lại máy hoặc đăng nhập vào TTY1 để phiên Umbriel + Noctalia tự động khởi chạy.

> **💡 Lưu ý về dọn dẹp hệ thống:**
> Hệ thống đã có sẵn **tự động dọn rác (Garbage Collection) mỗi tuần**. Đi kèm với đó là dịch vụ chạy ngầm tự động đồng bộ Bootloader (`switch-to-configuration boot`).

---

## 2. Quản lý Secrets

Mọi file bí mật (như SSH private key) được lưu trong thư mục `secrets/` đều đã được mã hóa bằng thuật toán Age thông qua công cụ `sops-nix`.

Để chỉnh sửa hoặc thêm bí mật mới, không được mở file yaml bằng text editor thông thường, mà phải dùng lệnh sau (yêu cầu máy đang có file keys.txt):

```bash
cd ~/nix-config
nix shell nixpkgs#sops -c sops secrets/secrets.yaml
```

Sops sẽ tự động giải mã file vào một vùng nhớ tạm, mở lên cho bạn chỉnh sửa, và tự động mã hóa lại khi bạn lưu file.

---

## 3. Backup định kỳ toàn bộ dữ liệu Zalo (tin nhắn + tệp phương tiện) ra ổ ngoài.

- Ổ đích: /mnt/dalu-occac (sda3, NTFS) — xem nixos/configuration.nix.
- Archive được nén (zstd) rồi mã hoá bằng age; recipient lấy từ .sops.yaml,
  giải mã cần identity ở ~/.config/sops/age/keys.txt.
- Các DB SQLite đang mở (Zalo đang chạy) được snapshot bằng `sqlite3 .backup`
  cho nhất quán, thay vì copy thô lúc đang ghi WAL.

Hướng dẫn sử dụng/restore: [./dalu_backup_usage.md](./modules/home-manager/system/dalu_backup_usage.md)
