# Custom Shell Scripts
# This module defines global shell scripts directly in Nix, replacing things in ~/.local/bin
{
  config,
  pkgs,
  ...
}: let
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

  proresConvert = pkgs.writeShellApplication {
    name = "prores-convert";
    runtimeInputs = [pkgs.ffmpeg pkgs.findutils pkgs.coreutils];
    text = ''
      profile="''${PROFILE:-2}"

      usage() {
        cat <<'EOF'
      Usage: prores-convert <file|directory>

      Chuyển video (H.264/H.265/...) sang Apple ProRes .mov để DaVinci Resolve
      bản free trên Linux đọc được (kèm audio PCM thay cho AAC).

        <file>       convert 1 file  -> <dir-của-file>/Converted/<tên>.mov
        <directory>  convert mọi video trong thư mục, không đệ quy
                                    -> <directory>/Converted/<tên>.mov

      Biến môi trường:
        PROFILE=1   ProRes 422 LT
        PROFILE=2   ProRes 422        (mặc định)
        PROFILE=3   ProRes 422 HQ
        PROFILE=4   ProRes 4444
      EOF
      }

      if [ "$#" -ne 1 ]; then
        usage >&2
        exit 2
      fi

      target="$1"

      if [ ! -e "$target" ]; then
        echo "prores-convert: không tồn tại: $target" >&2
        exit 1
      fi

      files=()
      if [ -d "$target" ]; then
        outdir="$target/Converted"
        while IFS= read -r -d "" f; do
          files+=("$f")
        done < <(find "$target" -mindepth 1 -maxdepth 1 -type f \
          \( -iname '*.mp4' -o -iname '*.mkv' -o -iname '*.mov' -o -iname '*.m4v' \
          -o -iname '*.webm' -o -iname '*.avi' -o -iname '*.flv' -o -iname '*.ts' \
          -o -iname '*.mts' -o -iname '*.m2ts' \) -print0 | sort -z)
        if [ "''${#files[@]}" -eq 0 ]; then
          echo "prores-convert: không tìm thấy file video nào trong $target" >&2
          exit 1
        fi
      else
        outdir="$(dirname "$target")/Converted"
        files=("$target")
      fi

      mkdir -p "$outdir"

      status=0
      for f in "''${files[@]}"; do
        base="$(basename "$f")"
        name="''${base%.*}"
        out="$outdir/$name.mov"

        codec="$(ffprobe -v error -select_streams v:0 \
          -show_entries stream=codec_name -of csv=p=0 "$f" || true)"
        if [ -z "$codec" ]; then
          echo "bỏ qua (không có video stream): $base" >&2
          continue
        fi
        if [ "$codec" = "prores" ]; then
          echo "bỏ qua (đã là ProRes): $base"
          continue
        fi
        if [ -e "$out" ]; then
          echo "bỏ qua (đã có): $out"
          continue
        fi

        echo "→ $base ($codec) => $out"
        if ! ffmpeg -nostdin -hide_banner -loglevel error -stats -i "$f" \
            -map 0:v:0 -map 0:a? \
            -c:v prores_ks -profile:v "$profile" -pix_fmt yuv422p10le -vendor apl0 \
            -c:a pcm_s16le \
            "$out"; then
          echo "LỖI: $base" >&2
          rm -f "$out"
          status=1
          continue
        fi

        size="$(du -h "$out" | cut -f1)"
        echo "   xong: $out ($size)"
      done

      exit "$status"
    '';
  };
in {
  home.packages = [
    concordTuiWezterm
    proresConvert
  ];
}
