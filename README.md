# NixOS & Home Manager Configuration

Hệ thống gồm hai phần:

- **NixOS (`nixosConfigurations.nixos`)**: Quản lý kernel, driver, bootloader và các dịch vụ cấp hệ thống.
- **Home Manager (`homeConfigurations."hinne@nixos"`)**: Quản lý dotfiles, terminal, CLI tools và apps.

## 📂 Cấu trúc thư mục

```text
~/nix-config/
    ├── ❄️ flake.nix
    ├── 🔒 flake.lock
    ├── ⚙️ .sops.yaml
    │
    ├── 💻 nixos/                  # Quản lý cấu hình hệ thống cấp Root (kernel, driver, services, waydroid)
    │   ├── configuration.nix
    │   ├── hardware-configuration.nix
    │   ├── damx.nix
    │   └── databases.nix
    │
    ├── 👤 home-manager/           # Quản lý cấu hình người dùng (apps, dotfiles, WM, terminal)
    │   ├── home.nix
    │   ├── tools.nix
    │   ├── scripts.nix
    │   ├── fastfetch.nix
    │   ├── fcitx5.nix
    │   ├── git.nix
    │   ├── zsh.nix
    │   ├── starship.nix
    │   ├── wezterm.nix
    │   ├── kitty.nix
    │   │
    │   ├── 🥭 mango/              # Cấu hình Window Manager MangoWM (Scroller, Vulkan, HDR10)
    │   ├── 🌙 noctalia/           # Cấu hình Desktop Shell/Bar Noctalia
    │   ├── 📝 nvim/               # Cấu hình trình soạn thảo Neovim
    │   └── 🎬 mpv/                # Cấu hình trình phát video MPV
    │
    └── 🗝️ secrets/                # Quản lý dữ liệu bảo mật mã hóa bằng SOPS (Age)
        └── secrets.yaml
```

---

## 1. Hướng dẫn cài đặt cho máy NixOS mới

### Bước 1.1: Phục hồi SOPS Key

Tạo thư mục và chép file `keys.txt` từ USB lưu trữ của bạn vào đúng vị trí cũ:

```bash
mkdir -p ~/.config/sops/age
# Chép file keys.txt vào thư mục trên
# Phân quyền bảo mật chặt chẽ cho file key:
chmod 600 ~/.config/sops/age/keys.txt
```

### Bước 1.2: Tải mã nguồn cấu hình

Sử dụng môi trường tạm thời của Nix để gọi Git và tải repo về:

```bash
nix-shell -p git
git clone https://github.com/DucHuynh27/nixos-dotfiles.git ~/nix-config
cd ~/nix-config
```

### Bước 1.3: Kích hoạt phần hệ thống (OS)

_Lưu ý: Nếu cài trên một phần cứng khác hoàn toàn, hãy tạo lại file hardware-configuration trước._

```bash
# (Tuỳ chọn) Tạo file hardware-configuration.nix cho máy mới:
# sudo nixos-generate-config --show-hardware-config > nixos/hardware-configuration.nix

# Áp dụng cấu hình NixOS:
sudo nixos-rebuild switch --flake .#nixos
# Hoặc dùng nh:
# nh os switch
```

### Bước 1.4: Kích hoạt phần người dùng (Home Manager)

Bước này sẽ thiết lập toàn bộ môi trường desktop (MangoWM, Noctalia), terminal (WezTerm), các công cụ CLI và tự động giải mã cấu hình secrets.
Vì công cụ `nh` đã được cài đặt ở Bước 1.3, chỉ cần:

```bash
nh home switch
```

Sau khi lệnh chạy xong, khởi động lại máy hoặc đăng nhập vào TTY1 để phiên làm việc MangoWM tự động khởi chạy.

> **💡 Lưu ý về dọn dẹp hệ thống:**
> Hệ thống đã có sẵn **tự động dọn rác (Garbage Collection) mỗi tuần**. Đi kèm với đó là dịch vụ chạy ngầm tự động đồng bộ Bootloader (`switch-to-configuration boot`).

---

## 2. Hướng dẫn quản lý Secrets

Mọi file bí mật (như SSH private key) được lưu trong thư mục `secrets/` đều đã được mã hóa bằng thuật toán Age thông qua công cụ `sops-nix`.

Để chỉnh sửa hoặc thêm bí mật mới, không được mở file yaml bằng text editor thông thường, mà phải dùng lệnh sau (yêu cầu máy đang có file keys.txt):

```bash
cd ~/nix-config
nix shell nixpkgs#sops -c sops secrets/secrets.yaml
```

Sops sẽ tự động giải mã file vào một vùng nhớ tạm, mở lên cho bạn chỉnh sửa, và tự động mã hóa lại khi bạn lưu file.
