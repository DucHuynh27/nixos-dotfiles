{
  config,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;

    font = {
      name = "Monaspace Argon Frozen";
      size = 14.0;
    };

    keybindings = {
      # Phím tắt chia cửa sổ dọc/ngang
      "ctrl+shift+enter" = "launch --location=hsplit";
      "ctrl+shift+o" = "launch --location=vsplit";

      # Di chuyển giữa các cửa sổ bằng vim keys
      "ctrl+shift+h" = "neighboring_window left";
      "ctrl+shift+j" = "neighboring_window down";
      "ctrl+shift+k" = "neighboring_window up";
      "ctrl+shift+l" = "neighboring_window right";

      # Phóng to/thu nhỏ cửa sổ (như zoom trong tmux)
      "ctrl+shift+z" = "toggle_layout stack";

      # Plugin search.py
      "ctrl+f" = "launch --location=vsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id";
    };

    settings = {
      bold_font = "auto";
      italic_font = "Monaspace Radon Frozen";
      bold_italic_font = "Monaspace Radon Frozen";
      disable_ligatures = "never";

      # Window decoration
      background_opacity = "1.0";
      background_blur = "1";
      window_padding_width = "10";
      window_padding_height = "10";
      hide_window_decorations = "yes";

      # Cursor settings
      cursor_shape = "beam";
      cursor_blink_interval = "0";
      cursor_trail = "3";
      cursor_trail_stack_size = "8";

      # Tab bar
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";

      # Scrollback
      scrollback_lines = "10000";

      # Enable config reload via `kitty @ reload-config`
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";

      # Bell
      enable_audio_bell = "no";

      # Window splitting settings
      enabled_layouts = "splits,stack";
    };

    # Monaspace: feature + icon fallback dạng dòng thô (settings chỉ nhận 1 giá trị/khoá)
    extraConfig = ''
      font_features MonaspaceArgonFrozen-Regular +calt +ss01 +ss02 +ss03 +ss07 +ss09 +liga
      font_features MonaspaceArgonFrozen-Bold +calt +ss01 +ss02 +ss03 +ss07 +ss09 +liga
      font_features MonaspaceRadonFrozen-Regular +calt +ss01 +ss02 +ss03 +ss07 +ss09 +liga
      font_features MonaspaceRadonFrozen-Bold +calt +ss01 +ss02 +ss03 +ss07 +ss09 +liga

      symbol_map U+23FB-U+23FE,U+2665,U+26A1,U+2B58,U+E000-U+E00A,U+F000-U+F2E0,U+F300-U+F372,U+F400-U+F532,U+F0001-U+F1AF0 Symbols Nerd Font Mono
    '';
  };

  # Set Kitty as the default terminal for GUI apps (like Noctalia) to launch CLI apps
  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = ["kitty.desktop"];
    };
  };
}
