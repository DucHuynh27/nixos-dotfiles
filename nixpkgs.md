# Hướng Dẫn Khai Báo Cài Đặt Ứng Dụng Chuẩn Trong Nix / NixOS

Tài liệu này tổng hợp các phương thức chuẩn để khai báo và cài đặt ứng dụng trong hệ sinh thái Nix / NixOS (không sử dụng Flatpak hay AppImage).

---

## 1. Bảng Tổng Quan & Tiêu Chí Lựa Chọn

| Phương thức | Khi nào nên dùng? | Vị trí khai báo thường gặp |
| :--- | :--- | :--- |
| **Cách 1: `systemPackages` / `home.packages`** | App đã có sẵn trên Nixpkgs, chỉ cần cài binary để dùng (không cần config phức tạp). | `nixos/configuration.nix` hoặc `home-manager/home.nix` |
| **Cách 2: Program Modules (`programs.<name>.*`)** | App có module hỗ trợ cấu hình dotfiles, plugins, theme tự động (Git, Neovim, VSCode, Firefox,...). | `home-manager/*.nix` hoặc `nixos/*.nix` |
| **Cách 3: Flake Inputs (`inputs.<name>.packages`)** | App chưa vào Nixpkgs chính thức hoặc muốn dùng bản bleeding-edge trực tiếp từ tác giả (Zen Browser, Ghostty,...). | `flake.nix` -> `specialArgs` -> `packages` |
| **Cách 4: Package Derivation (`callPackage` / `mkDerivation`)** | Tự đóng gói binary prebuilt (.tar.gz, .deb), tool tự code, hoặc app mã nguồn mở chưa có trên Nix. | `pkgs/<app>/default.nix` |

---

## 2. Chi Tiết Từng Phương Thức

### Cách 1: Khai Báo App Có Sẵn Trên Nixpkgs

#### Bước 1: Tra cứu package
```bash
# Tìm kiếm bằng CLI
nix search nixpkgs <tên-app>

# Hoặc tra cứu trực quan tại:
# https://search.nixos.org/packages
```

#### Bước 2: Khai báo vào file cấu hình
- **Cài đặt System-wide (toàn hệ thống):**
  Thường dùng cho system utilities, CLI tools cho mọi user:
  ```nix
  # nixos/configuration.nix
  { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      btop
      ripgrep
      pciutils
      curl
    ];
  }
  ```

- **Cài đặt User-level (Khuyến nghị cho Desktop Apps):**
  Khai báo qua Home-Manager:
  ```nix
  # home-manager/home.nix
  { pkgs, ... }: {
    home.packages = with pkgs; [
      discord
      obsidian
      spotify
      vlc
    ];
  }
  ```

---

### Cách 2: Sử Dụng `programs.<name>` Module (Quản Lý Cả Cấu Hình)

NixOS và Home-Manager cung cấp rất nhiều module đóng gói sẵn, tự động sinh cấu hình, quản lý extensions và tích hợp hệ thống.

Tra cứu module có sẵn: [search.nixos.org/options](https://search.nixos.org/options)

#### Ví dụ trong Home-Manager:
```nix
# home-manager/home.nix
{ pkgs, ... }: {
  # Git: Tự tạo ~/.gitconfig
  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "you@example.com";
  };

  # VSCode: Tự quản lý extension và settings
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      rust-lang.rust-analyzer
    ];
    userSettings = {
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', monospace";
      "editor.fontSize" = 14;
    };
  };

  # Shell (Fish / Zsh / Bash)
  programs.fish = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake .#default";
    };
  };
}
```

---

### Cách 3: Lấy Trực Tiếp Từ GitHub Flakes

Áp dụng khi ứng dụng chưa có trên Nixpkgs hoặc bạn cần phiên bản mới nhất được duy trì bởi chính tác giả repo.

#### Bước 1: Khai báo input trong `flake.nix`
```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Khai báo Flake của ứng dụng bên ngoài
    zen-browser = {
      url = "github:you/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.your-host = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; }; # Truyền inputs vào các module con
      modules = [ ./nixos/configuration.nix ];
    };
  };
}
```

#### Bước 2: Thêm package vào danh sách cần cài
```nix
# Trong configuration.nix hoặc home.nix:
{ pkgs, inputs, ... }: {
  home.packages = [
    inputs.zen-browser.packages.${pkgs.system}.default
  ];
}
```

---

### Cách 4: Tự Viết Package Derivation (Tự Đóng Gói)

Áp dụng cho prebuilt binary (.tar.gz, .deb), script tự viết, hoặc app build từ source.

#### Bước 1: Viết derivation (`pkgs/my-app/default.nix`)
```nix
{ lib
, stdenv
, fetchurl
, makeWrapper
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "my-app";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/user/my-app/releases/download/v${version}/my-app-linux-x86_64.tar.gz";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Để rỗng để Nix báo hash thực tế
  };

  # Dùng autoPatchelfHook nếu đây là binary ELF thông thường cần liên kết dynamic libraries
  nativeBuildInputs = [ makeWrapper autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp my-app $out/bin/
    chmod +x $out/bin/my-app
    runHook postInstall
  '';

  meta = with lib; {
    description = "Ứng dụng tự đóng gói";
    platforms = platforms.linux;
  };
}
```

#### Bước 2: Gọi package trong module
```nix
{ pkgs, ... }: {
  home.packages = [
    (pkgs.callPackage ./pkgs/my-app { })
  ];
}
```

---

## 3. Sơ Đồ Quyết Định (Decision Tree)

```text
Cần cài một ứng dụng mới?
│
├── 1. Tra cứu trên https://search.nixos.org
│    ├── Có tùy chọn `programs.<name>`?
│    │    └──> Dùng Cách 2 (programs.<name>.*) để quản lý cả dotfile/config.
│    │
│    └── Chỉ có package trong nixpkgs?
│         └──> Dùng Cách 1 (environment.systemPackages hoặc home.packages).
│
└── 2. Không có trên Nixpkgs?
     ├── Tác giả có repo Flake trên GitHub?
     │    └──> Dùng Cách 3 (Flake inputs.<app>).
     │
     └── Chỉ có file release (.tar.gz, .deb, script)?
          └──> Dùng Cách 4 (Tự viết stdenv.mkDerivation / pkgs.callPackage).
```
