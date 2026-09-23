# Zsh and Terminal Utilities Configuration
# This module sets up Zsh, aliases, and related tools (starship, zoxide, eza).
{
  config,
  pkgs,
  ...
}: {
  # Zsh configuration
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
      cleanup = "~/.local/bin/cleanup-system.sh";
      grep = "grep --color=auto";
      jctl = "journalctl -p 3 -xb";
      la = "eza -a --color=always --group-directories-first --icons";
      ll = "eza -l --color=always --group-directories-first --icons";
      ls = "eza -al --color=always --group-directories-first --icons";
      lt = "eza -aT --color=always --group-directories-first --icons";
      v = "nvim";
      dotfiles = "/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
      live = "pnpm dlx live-server";
      quickwin10 = "cd ~/VMs && quickemu --vm windows-10.conf";
      fan-auto = "echo 0,0 | sudo tee /sys/devices/platform/acer-wmi/nitro_sense/fan_speed";
      fan-max = "echo 100,100 | sudo tee /sys/devices/platform/acer-wmi/nitro_sense/fan_speed";
      fan-med = "echo 60,60 | sudo tee /sys/devices/platform/acer-wmi/nitro_sense/fan_speed";
      bat-limit-on = "echo 1 | sudo tee /sys/devices/platform/acer-wmi/nitro_sense/battery_limiter";
      bat-limit-off = "echo 0 | sudo tee /sys/devices/platform/acer-wmi/nitro_sense/battery_limiter";

      # MSSQL & MySQL (Docker)
      sql-start = "systemctl start docker-mssql";
      sql-stop = "systemctl stop docker-mssql";
      sql-status = "systemctl status docker-mssql";
      sql-log = "journalctl -u docker-mssql -f";

      mysql-start = "systemctl start docker-mysql";
      mysql-stop = "systemctl stop docker-mysql";
      mysql-status = "systemctl status docker-mysql";
      mysql-log = "journalctl -u docker-mysql -f";

      lzd = "lazydocker";
    };

    # Extra configuration added to ~/.zprofile for login shells
    profileExtra = ''
      # Autostart MangoWM on TTY login
      if [[ -o interactive ]] && [ -z "$WAYLAND_DISPLAY" ] && [ -z "$DISPLAY" ]; then
        if [ "$(tty)" = "/dev/tty1" ]; then
          export XDG_CURRENT_DESKTOP=mango
          export XDG_SESSION_TYPE=wayland
          export WLR_RENDERER=vulkan
          exec mango > ~/.mango.log 2>&1
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
