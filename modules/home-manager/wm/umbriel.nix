{
  ...
}: {
  # Symlink cấu hình Umbriel tới ~/.config/umbriel/config.toml
  # (bảng màu động do Noctalia sinh ở ~/.config/umbriel/noctalia.toml).
  xdg.configFile."umbriel/config.toml" = {
    source = ./umbriel/config.toml;
    force = true;
  };
}
