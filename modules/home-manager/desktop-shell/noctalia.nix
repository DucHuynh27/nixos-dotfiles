{
  config,
  ...
}: {
  # Use recursive to allow Noctalia GUI to save settings
  xdg.configFile."noctalia".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home-manager/desktop-shell/noctalia";

  # Noctalia được Umbriel tự autostart (xem wm/umbriel/config.toml -> [general] autostart),
  # nên không cần systemd service riêng.
}
