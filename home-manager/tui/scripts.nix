# Custom Shell Scripts
# This module defines global shell scripts directly in Nix, replacing things in ~/.local/bin
{
  config,
  pkgs,
  ...
}: let
  deepseekBalance = pkgs.writeShellApplication {
    name = "deepseek-balance";
    runtimeInputs = [
      pkgs.curl
      pkgs.jq
    ];
    text = ''
      set -euo pipefail

      state_file="''${XDG_STATE_HOME:-$HOME/.local/state}/deepseek-balance/details"
      mkdir -p "$(dirname "$state_file")"

      case "''${1:-}" in
        --toggle)
          if [ -f "$state_file" ] && [ "$(<"$state_file")" = "1" ]; then
            printf '0\n' >"$state_file"
          else
            printf '1\n' >"$state_file"
          fi
          exit 0
          ;;
        --refresh)
          exit 0
          ;;
      esac

      api_key="''${DEEPSEEK_API_KEY:-}"
      api_key_file="''${DEEPSEEK_API_KEY_FILE:-${config.home.homeDirectory}/.config/secrets/deepseek-api-key}"
      if [ -n "$api_key_file" ]; then
        if [ ! -r "$api_key_file" ]; then
          printf 'deepseek-balance: cannot read %s\n' "$api_key_file" >&2
          exit 1
        fi
        api_key=$(<"$api_key_file")
      fi

      if [ -z "$api_key" ]; then
        printf 'deepseek-balance: set DEEPSEEK_API_KEY or create %s\n' "$api_key_file" >&2
        exit 1
      fi

      currency="''${DEEPSEEK_BALANCE_CURRENCY:-}"
      response_file=$(mktemp)
      trap 'rm -f "$response_file"' EXIT

      http_status=$(
        curl \
          --silent \
          --show-error \
          --location \
          --connect-timeout 5 \
          --max-time 15 \
          --output "$response_file" \
          --write-out '%{http_code}' \
          --header 'Accept: application/json' \
          --header "Authorization: Bearer $api_key" \
          'https://api.deepseek.com/user/balance'
      )

      if [ "$http_status" -lt 200 ] || [ "$http_status" -ge 300 ]; then
        error_message=$(jq -r '.error.message // .message // empty' "$response_file" 2>/dev/null || true)
        if [ -n "$error_message" ]; then
          printf 'deepseek-balance: HTTP %s: %s\n' "$http_status" "$error_message" >&2
        else
          printf 'deepseek-balance: HTTP %s\n' "$http_status" >&2
        fi
        exit 1
      fi

      if ! jq -e . "$response_file" >/dev/null; then
        printf 'deepseek-balance: API returned invalid JSON\n' >&2
        exit 1
      fi

      balance=$(
        jq -er --arg currency "$currency" '
          .balance_infos[]
          | select($currency == "" or .currency == $currency)
          | [.currency, .total_balance, .granted_balance, .topped_up_balance]
          | @tsv
        ' "$response_file"
      ) || {
        if [ -n "$currency" ]; then
          printf 'deepseek-balance: no balance found for currency %s\n' "$currency" >&2
        else
          printf 'deepseek-balance: API returned no balances\n' >&2
        fi
        exit 1
      }
      IFS=$'\t' read -r currency total_balance granted_balance topped_up_balance <<< "$balance"

      if [ "''${1:-}" = "--json" ]; then
        if [ -f "$state_file" ] && [ "$(<"$state_file")" = "1" ]; then
          text="Top-up: $topped_up_balance | Granted: $granted_balance | Remaining: $total_balance $currency"
          tooltip="DeepSeek API\nTop-up: $topped_up_balance $currency\nGranted: $granted_balance $currency\nRemaining: $total_balance $currency"
        else
          text="Remaining: $total_balance $currency"
          tooltip="DeepSeek API: Remaining $total_balance $currency"
        fi
        jq -cn \
          --arg currency "$currency" \
          --arg total_balance "$total_balance" \
          --arg granted_balance "$granted_balance" \
          --arg topped_up_balance "$topped_up_balance" \
          --arg text "$text" \
          --arg tooltip "$tooltip" \
          '{
            currency: $currency,
            total_balance: $total_balance,
            granted_balance: $granted_balance,
            topped_up_balance: $topped_up_balance,
            text: $text,
            tooltip: $tooltip
          }'
      else
        printf 'Remaining: %s %s\n' "$total_balance" "$currency"
      fi
    '';
  };

  shellMsg = pkgs.writeShellApplication {
    name = "shell-msg";
    runtimeInputs = with pkgs; [
      brightnessctl
      noctalia
      wayle
    ];
    text = ''
      set -euo pipefail

      shell="''${MANGO_SHELL:-noctalia}"
      action="''${1:-}"

      if [ "$shell" = "noctalia" ]; then
        case "$action" in
          volume-up) exec noctalia msg volume-up ;;
          volume-down) exec noctalia msg volume-down ;;
          volume-mute) exec noctalia msg volume-mute ;;
          mic-mute) exec noctalia msg mic-mute ;;
          media-toggle) exec noctalia msg media toggle ;;
          media-next) exec noctalia msg media next ;;
          media-prev) exec noctalia msg media previous ;;
          brightness-up) exec noctalia msg brightness-up ;;
          brightness-down) exec noctalia msg brightness-down ;;
        esac
      else
        case "$action" in
          volume-up) exec wayle audio output-volume +5 ;;
          volume-down) exec wayle audio output-volume -5 ;;
          volume-mute) exec wayle audio output-mute ;;
          mic-mute) exec wayle audio input-mute ;;
          media-toggle) exec wayle media play-pause ;;
          media-next) exec wayle media next ;;
          media-prev) exec wayle media previous ;;
          brightness-up) exec brightnessctl set 5%+ ;;
          brightness-down) exec brightnessctl set 5%- ;;
        esac
      fi

      printf 'shell-msg: unknown action: %s\n' "$action" >&2
      exit 1
    '';
  };

  secureUpdate = pkgs.writeShellScriptBin "secure-update" ''
    #!/bin/bash
    # Script cập nhật hệ thống an toàn - Heuristic Security Scanner
    # Natively managed by Nix Home Manager

    echo "--- [1/3] Đang quét Heuristic An ninh trên AUR Cache ---"

    # 1. Quét các IOC đã biết
    IOC_KNOWN=$(grep -rE "atomic-lockfile|js-digest|arch-audit-fix" ~/.cache/yay ~/.cache/paru 2>/dev/null)

    # 2. Quét hành vi: Downloader
    IOC_DOWNLOADER=$(grep -rE "(curl|wget).*\|.*(bash|sh|python|node|perl)" ~/.cache/yay ~/.cache/paru 2>/dev/null)

    # 3. Quét hành vi: Obfuscation
    IOC_OBFUSCATION=$(grep -rE "[a-zA-Z0-9+/]{100,}" ~/.cache/yay ~/.cache/paru 2>/dev/null | grep "PKGBUILD" | grep -vE "(sums|sha[0-9]*|b2|md5)" | grep -vE "['\"][a-f0-9]{64,}['\"]")

    # 4. Quét hành vi: Persistence
    IOC_PERSISTENCE=$(grep -rE "cp.*(/etc/systemd|/var/spool/cron|/etc/init.d)" ~/.cache/yay ~/.cache/paru 2>/dev/null)

    if [ -n "$IOC_KNOWN" ] || [ -n "$IOC_DOWNLOADER" ] || [ -n "$IOC_OBFUSCATION" ] || [ -n "$IOC_PERSISTENCE" ]; then
        echo "⚠️ CẢNH BÁO: Phát hiện dấu hiệu bất thường trong AUR Cache!"
        [ -n "$IOC_KNOWN" ] && echo "- Tìm thấy mã độc đã biết."
        [ -n "$IOC_DOWNLOADER" ] && echo "- Tìm thấy script tải file thực thi trực tiếp."
        [ -n "$IOC_OBFUSCATION" ] && echo "- Tìm thấy mã nguồn bị mã hóa (Obfuscation)."
        [ -n "$IOC_PERSISTENCE" ] && echo "- Tìm thấy nỗ lực cài đặt file hệ thống."
        exit 1
    fi

    echo "--- [2/3] Bắt đầu cập nhật hệ thống ---"
    yay -Syu

    echo "--- [3/3] Đang thực hiện dọn dẹp & fix lỗi ---"
    [ -x /usr/bin/flatpak ] && flatpak update -y

    echo "Đang làm sạch cache để bảo mật..."
    rm -rf ~/.cache/paru/clone/*
    rm -rf ~/.cache/yay/*

    echo "✅ Hệ thống đã được cập nhật an toàn."
  '';

  concordTuiWezterm = pkgs.writeShellApplication {
    name = "concord-tui-wezterm";
    runtimeInputs = [pkgs.wezterm pkgs.concord-tui];
    text = ''
      secret_file="${config.home.homeDirectory}/.config/secrets/deepl-api-key"
      if [ ! -r "$secret_file" ]; then
        printf 'concord: cannot read DeepL API key from %s\n' "$secret_file" >&2
        exit 1
      fi
      DEEPL_API_KEY="$(<"$secret_file")"
      export DEEPL_API_KEY

      exec wezterm \
        start -- \
        concord "$@"
    '';
  };
in {
  home.packages = [
    deepseekBalance
    secureUpdate
    shellMsg
    concordTuiWezterm
  ];
}
