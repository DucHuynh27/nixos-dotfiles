# Zsh and Terminal Utilities Configuration
{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;

    # Enable syntax highlighting and autosuggestions
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # History settings
    history = {
      size = 10000;
      save = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    # Shell aliases
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../../..";

      c = "clear";

      grep = "grep --color=auto";

      jctl = "journalctl -p 3 -xb";

      la = "eza -a --color=always --group-directories-first --icons";
      ll = "eza -l --color=always --group-directories-first --icons";
      ls = "eza -al --color=always --group-directories-first --icons";
      lt = "eza -aT --color=always --group-directories-first --icons";

      v = "nvim";

      # Git aliases
      gs = "git status";
      gb = "git branch";
      gc = "git commit";
      gp = "git push";
      gco = "git checkout";

      dotfiles = "/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";

      live = "pnpm dlx live-server";

      # Acer Nitro (nitro-linux)
      nitro-tui = "nitro-linux";
      nitro-status = "nitro status";
      nitro-fan-auto = "echo auto | sudo tee /sys/devices/platform/nitro/fan_mode";
      nitro-fan-max = "echo max | sudo tee /sys/devices/platform/nitro/fan_mode";
      nitro-fan-cpu = "sudo nitro fan cpu";
      nitro-fan-gpu = "sudo nitro fan gpu";

      # Battery health (acer-wmi-battery)
      bat-limit-on = "echo 1 | sudo tee /sys/bus/wmi/drivers/acer-wmi-battery/health_mode";
      bat-limit-off = "echo 0 | sudo tee /sys/bus/wmi/drivers/acer-wmi-battery/health_mode";
      bat-limit-status = "cat /sys/bus/wmi/drivers/acer-wmi-battery/health_mode";

      # Databases (rootless Podman, managed by Mini Docker)
      sql-start = "podman start db-mssql";
      sql-stop = "podman stop db-mssql";
      sql-status = "podman ps -a --filter name=db-mssql";
      sql-log = "podman logs -f db-mssql";

      mysql-start = "podman start db-mysql";
      mysql-stop = "podman stop db-mysql";
      mysql-status = "podman ps -a --filter name=db-mysql";
      mysql-log = "podman logs -f db-mysql";

      mongo-start = "podman start db-mongodb";
      mongo-stop = "podman stop db-mongodb";
      mongo-status = "podman ps -a --filter name=db-mongodb";
      mongo-log = "podman logs -f db-mongodb";

      pg-start = "podman start db-postgres";
      pg-stop = "podman stop db-postgres";
      pg-status = "podman ps -a --filter name=db-postgres";
      pg-log = "podman logs -f db-postgres";

      db-start-all = "podman start db-postgres db-mysql db-mongodb db-mssql";
      db-stop-all = "podman stop db-postgres db-mysql db-mongodb db-mssql";
      db-status = "podman ps -a --filter name=db-";

      lzd = "lazydocker";

      # Network speed test (on-demand, byte units MB/s)
      speedtest = "nix run nixpkgs#speedtest-cli -- --bytes";

      # System & Packages Upgrade
      upgrade-pkgs = "nix flake update --flake ~/nix-config && sudo nixos-rebuild switch --flake ~/nix-config#nixos";

      # Cleanup older generations (keep only last 3 generations) and collect garbage
      cleanup = "nix-env --delete-generations +3 && sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +3 && nix-collect-garbage && sudo nix-collect-garbage && nix store optimise";
    };

    # Extra configuration added to ~/.zprofile for login shells
    profileExtra = ''
        # Autostart Mango sessions on TTY login.
        # tty1 -> Noctalia shell, tty2 -> Wayle shell (selected via MANGO_SHELL).
        if [[ -o interactive ]] && [ -z "$WAYLAND_DISPLAY" ] && [ -z "$DISPLAY" ]; then
          if [ "$(tty)" = "/dev/tty1" ]; then
            export XDG_CURRENT_DESKTOP=mango
            export XDG_SESSION_DESKTOP=mango
            export XDG_SESSION_TYPE=wayland
            export WLR_RENDERER=vulkan
            export MANGO_SHELL=noctalia
            exec mango > ~/.mango-noctalia.log 2>&1

          elif [ "$(tty)" = "/dev/tty2" ]; then
            export XDG_CURRENT_DESKTOP=mango
            export XDG_SESSION_DESKTOP=mango
            export XDG_SESSION_TYPE=wayland
            export WLR_RENDERER=vulkan
            export MANGO_SHELL=wayle
            exec mango > ~/.mango-wayle.log 2>&1

        fi
      fi
    '';

    # Extra configuration added to ~/.zshrc
    initContent = ''
      # Set shell options
      setopt HIST_FCNTL_LOCK NO_APPEND_HISTORY NO_EXTENDED_HISTORY
      setopt NO_HIST_FIND_NO_DUPS NO_HIST_IGNORE_ALL_DUPS NO_HIST_SAVE_NO_DUPS

      # Quick activate venv function
      va() {
          if [[ -f "venv/bin/activate" ]]; then
              source venv/bin/activate
          elif [[ -f ".venv/bin/activate" ]]; then
              source .venv/bin/activate
          else
              echo "Lỗi: Không tìm thấy môi trường ảo (venv hoặc .venv)"
          fi
      }

      # fnm (Fast Node Manager) integration
      if command -v fnm &> /dev/null; then
          eval "$(fnm env --use-on-cd --shell zsh)"
      fi
    '';
  };

  # Zoxide (better cd)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"]; # alias cd="z"
  };

  # Eza (better ls)
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };
}
