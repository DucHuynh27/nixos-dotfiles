{
  lib,
  pkgs,
  ...
}: let
  # AAGL (An Anime Game Launcher) lưu toàn bộ cấu hình trong user-data, không
  # phải nix-config:
  #   ~/.local/share/anime-game-launcher/config.json -> .game.wine.borderless
  #
  # Vì sao ép borderless: Genshin chạy exclusive fullscreen qua Wine/XWayland
  # làm Umbriel nuốt cú nhấn chuột. Đo bằng evtest (kernel) đối chiếu xev
  # (X server), cùng điều kiện, click vào cửa sổ xev trong lúc game mở:
  #   - exclusive fullscreen : kernel 17 press -> X server chỉ 13 (mất ~24%,
  #                            có ca nuốt press nhưng vẫn gửi release)
  #   - borderless           : 28 press -> 26 (chỉ mất cặp click rơi ra ngoài
  #                            cửa sổ, không còn kiểu lệch press/release)
  #   - không mở game        : 27 -> 27, 0 mất
  # Nên "borderless" là điều kiện để click ăn đủ; wrapper này đảm bảo setting
  # đó luôn được ghi lại trước mỗi lần chạy, kể cả khi AAGL reset config.
  launcher = "/run/current-system/sw/bin/anime-game-launcher";

  anime-game-launcher = pkgs.writeShellApplication {
    name = "anime-game-launcher";
    runtimeInputs = [pkgs.jq];
    text = ''
      cfg="''${XDG_DATA_HOME:-$HOME/.local/share}/anime-game-launcher/config.json"

      # Chỉ patch khi config đã tồn tại; lần chạy đầu (wizard) để AAGL tự tạo.
      if [ -f "$cfg" ]; then
        tmp="$(mktemp)"
        if jq '.game.wine.borderless = true' "$cfg" > "$tmp" 2>/dev/null; then
          cat "$tmp" > "$cfg"
        else
          echo "anime-game-launcher: không patch được $cfg, chạy với config hiện tại" >&2
        fi
        rm -f "$tmp"
      fi

      exec ${launcher} "$@"
    '';
  };
in {
  home.packages = [anime-game-launcher];

  # home.sessionPath được prepend nên ~/.local/bin đứng TRƯỚC
  # ~/.nix-profile/bin -> file ~/.local/bin/anime-game-launcher (hack cũ từ
  # 2026-09-19: `export DISPLAY=:1` + exec launcher) sẽ che wrapper ở trên.
  # Thay nó bằng chính wrapper để gọi theo tên ở đâu cũng qua bước patch.
  home.file.".local/bin/anime-game-launcher" = {
    source = "${anime-game-launcher}/bin/anime-game-launcher";
    force = true;
  };

  # Desktop entry hệ thống trỏ thẳng vào store path của AAGL nên sẽ bỏ qua
  # wrapper ở trên -> đè bằng entry cùng tên trong ~/.local/share/applications.
  xdg.desktopEntries.anime-game-launcher = {
    name = "An Anime Game Launcher";
    genericName = "An Anime Game Launcher";
    exec = "${anime-game-launcher}/bin/anime-game-launcher";
    icon = "moe.launcher.an-anime-game-launcher";
    categories = ["Game"];
    startupNotify = true;
    settings.StartupWMClass = "moe.launcher.an-anime-game-launcher";
  };

  # Áp ngay khi switch để lần chạy đầu tiên sau rebuild đã đúng, không phải
  # chờ wrapper.
  home.activation.animeGameLauncherBorderless = lib.hm.dag.entryAfter ["writeBoundary"] ''
    cfg="''${XDG_DATA_HOME:-$HOME/.local/share}/anime-game-launcher/config.json"
    if [ -f "$cfg" ]; then
      tmp="$(mktemp)"
      if ${pkgs.jq}/bin/jq '.game.wine.borderless = true' "$cfg" > "$tmp" 2>/dev/null; then
        cat "$tmp" > "$cfg"
      fi
      rm -f "$tmp"
    fi
  '';
}
