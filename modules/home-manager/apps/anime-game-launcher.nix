{
  lib,
  pkgs,
  ...
}: let
  launcher = "/run/current-system/sw/bin/anime-game-launcher";

  anime-game-launcher = pkgs.writeShellApplication {
    name = "anime-game-launcher";
    runtimeInputs = [pkgs.jq];
    text = ''
      cfg="''${XDG_DATA_HOME:-$HOME/.local/share}/anime-game-launcher/config.json"

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

  home.file.".local/bin/anime-game-launcher" = {
    source = "${anime-game-launcher}/bin/anime-game-launcher";
    force = true;
  };

  xdg.desktopEntries.anime-game-launcher = {
    name = "An Anime Game Launcher";
    genericName = "An Anime Game Launcher";
    exec = "${anime-game-launcher}/bin/anime-game-launcher";
    icon = "moe.launcher.an-anime-game-launcher";
    categories = ["Game"];
    startupNotify = true;
    settings.StartupWMClass = "moe.launcher.an-anime-game-launcher";
  };

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
