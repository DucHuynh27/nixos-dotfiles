# Umbriel Configuration Module
{
  config,
  pkgs,
  ...
}: {
  # Symlink umbriel config file to ~/.config/umbriel/config.toml
  xdg.configFile."umbriel/config.toml".source = ./umbriel/config.toml;
}
