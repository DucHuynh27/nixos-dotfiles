# Backup định kỳ toàn bộ dữ liệu Zalo (tin nhắn + tệp phương tiện) ra ổ ngoài.
#
# - Ổ đích: /mnt/dalu-occac (sda3, NTFS) — xem nixos/configuration.nix.
# - Archive được nén (zstd) rồi mã hoá bằng age; recipient lấy từ .sops.yaml,
#   giải mã cần identity ở ~/.config/sops/age/keys.txt.
# - Các DB SQLite đang mở (Zalo đang chạy) được snapshot bằng `sqlite3 .backup`
#   cho nhất quán, thay vì copy thô lúc đang ghi WAL.
#
# Hướng dẫn sử dụng/restore: ./dalu_backup_usage.md
{
  config,
  lib,
  pkgs,
  ...
}: let
  homeDir = config.home.homeDirectory;
  zaloData = "${homeDir}/.config/ZaloData";
  mountPoint = "/mnt/dalu-occac";
  backupDir = "${mountPoint}/zalo-backup";
  ageIdentity = "${homeDir}/.config/sops/age/keys.txt";
  # Public key (recipient) — không phải secret, lấy từ .sops.yaml.
  ageRecipient = "age1t4wkm4w9lxlkqtaf9226609lw2raqvsxzac2aq89zhm9553f0fmqaxcjr6";
  keep = 7;

  # Thư mục chỉ chứa cache/ML model, tự sinh lại được -> bỏ cho nhẹ.
  cacheExcludes = [
    "Cache/"
    "Code Cache/"
    "GPUCache/"
    "DawnCache/"
    "resp_cache/"
    "tf-models/"
    "Crashpad/"
    "blob_storage/"
    # File runtime của Chromium (lock/socket theo PID), không nên backup.
    "Singleton*"
  ];
  excludeArgs = lib.concatMapStringsSep " " (p: "--exclude '${p}'") cacheExcludes;

  zaloBackup = pkgs.writeShellApplication {
    name = "zalo-backup";
    runtimeInputs = with pkgs; [
      coreutils
      findutils
      gnugrep
      sqlite
      util-linux
      procps
      rsync
      gnutar
      zstd
      age
    ];
    text = ''
      mountPoint="${mountPoint}"
      backupDir="${backupDir}"
      zaloData="${zaloData}"
      ageRecipient="${ageRecipient}"
      keep=${toString keep}
      stagingRoot="${homeDir}/.cache/zalo-backup"

      if ! mountpoint -q "$mountPoint"; then
        echo "zalo-backup: $mountPoint chưa được mount -> bỏ qua." >&2
        exit 0
      fi

      if [ ! -d "$zaloData" ]; then
        echo "zalo-backup: không thấy $zaloData -> bỏ qua." >&2
        exit 0
      fi

      mkdir -p "$backupDir"

      exec 9>/tmp/zalo-backup.lock
      if ! flock -n 9; then
        echo "zalo-backup: đã có tiến trình backup khác đang chạy -> bỏ qua." >&2
        exit 0
      fi

      if pgrep -f 'zalo-26.11.10-extracted' >/dev/null 2>&1; then
        echo "zalo-backup: Zalo đang chạy; DB sẽ snapshot bằng 'sqlite3 .backup'." >&2
      fi

      mkdir -p "$stagingRoot"
      staging="$(mktemp -d "$stagingRoot/staging.XXXXXX")"
      trap 'rm -rf "$staging"' EXIT

      # 1) Copy mọi thứ, TRỪ cache và TRỪ các file DB (*.db sẽ snapshot riêng).
      rsync -a ${excludeArgs} \
        --exclude '*.db' --exclude '*.db-wal' --exclude '*.db-shm' \
        "$zaloData/" "$staging/"

      # 2) Snapshot nhất quán từng *.db (gộp WAL, an toàn khi app đang mở).
      while IFS= read -r db; do
        rel="''${db#"$zaloData"/}"
        dest="$staging/$rel"
        mkdir -p "$(dirname "$dest")"
        if head -c 15 "$db" | grep -q 'SQLite format'; then
          if ! sqlite3 "$db" ".backup '$dest'"; then
            echo "zalo-backup: sqlite3 .backup lỗi ở $rel, dùng copy thô." >&2
            cp -f "$db" "$dest"
          fi
        else
          cp -f "$db" "$dest"
        fi
      done < <(find "$zaloData" -type f -name '*.db')

      # 3) Đóng gói | nén | mã hoá.
      ts="$(date +%Y%m%d-%H%M%S)"
      name="zalo-$ts.tar.zst.age"
      out="$backupDir/$name"

      echo "zalo-backup: tạo $out ..."
      tar -C "$staging" -cf - . | zstd -19 -T0 | age -r "$ageRecipient" -o "$out"

      # 4) Checksum (ghi tên tương đối để 'sha256sum -c' chạy trong backupDir).
      (
        cd "$backupDir"
        sha256sum "$name" > "$name.sha256"
      )

      # 5) Rotation: giữ $keep bản mới nhất.
      find "$backupDir" -maxdepth 1 -type f -name 'zalo-*.tar.zst.age' -printf '%T@\t%p\n' \
        | sort -rn \
        | tail -n +$((keep + 1)) \
        | cut -f2- \
        | while IFS= read -r old; do
            echo "zalo-backup: xoá bản cũ $(basename "$old")"
            rm -f "$old" "$old.sha256"
          done

      echo "zalo-backup: hoàn tất -> $out"
    '';
  };

  zaloRestore = pkgs.writeShellApplication {
    name = "zalo-restore";
    runtimeInputs = with pkgs; [
      coreutils
      findutils
      procps
      rsync
      gnutar
      zstd
      age
    ];
    text = ''
      zaloData="${zaloData}"
      ageIdentity="${ageIdentity}"

      archive="''${1:-}"
      if [ -z "$archive" ]; then
        echo "Dùng: zalo-restore <archive.tar.zst.age>" >&2
        exit 2
      fi
      if [ ! -r "$archive" ]; then
        echo "zalo-restore: không đọc được archive: $archive" >&2
        exit 1
      fi
      if [ ! -r "$ageIdentity" ]; then
        echo "zalo-restore: thiếu age identity: $ageIdentity" >&2
        exit 1
      fi

      if pgrep -f 'zalo-26.11.10-extracted' >/dev/null 2>&1; then
        echo "zalo-restore: đang tắt Zalo..." >&2
        pkill -TERM -f 'zalo-26.11.10-extracted' || true
        sleep 4
        pkill -KILL -f 'zalo-26.11.10-extracted' 2>/dev/null || true
        sleep 1
      fi

      staging="$(mktemp -d /tmp/zalo-restore.XXXXXX)"
      trap 'rm -rf "$staging"' EXIT

      echo "zalo-restore: giải mã + bung archive..." >&2
      age -d -i "$ageIdentity" "$archive" | zstd -d -T0 | tar -xf - -C "$staging"

      if [ -z "$(find "$staging" -mindepth 1 -maxdepth 1 -print -quit)" ]; then
        echo "zalo-restore: archive rỗng hoặc giải nén thất bại." >&2
        exit 1
      fi

      ts="$(date +%Y%m%d-%H%M%S)"
      if [ -e "$zaloData" ]; then
        echo "zalo-restore: dời dữ liệu hiện tại -> $zaloData.bak-$ts" >&2
        mv "$zaloData" "$zaloData.bak-$ts"
      fi
      mkdir -p "$zaloData"
      rsync -a "$staging/" "$zaloData/"

      echo "zalo-restore: hoàn tất -> $zaloData" >&2
      echo "zalo-restore: bản cũ (nếu có) -> $zaloData.bak-$ts" >&2
    '';
  };
in {
  home.packages = [zaloBackup zaloRestore];

  systemd.user.services.zalo-backup = {
    Unit = {
      Description = "Backup dữ liệu Zalo (mã hoá age) ra ${mountPoint}";
      ConditionPathIsMountPoint = mountPoint;
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${zaloBackup}/bin/zalo-backup";
    };
  };

  systemd.user.timers.zalo-backup = {
    Unit.Description = "Backup Zalo hằng ngày lúc 00:00";
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "10m";
    };
    Install.WantedBy = ["timers.target"];
  };
}
