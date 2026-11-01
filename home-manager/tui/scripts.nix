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
in {
  home.packages = [
    concordTuiWezterm
  ];
}
