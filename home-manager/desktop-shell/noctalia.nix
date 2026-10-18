# Noctalia Shell Configuration Module
{
  config,
  pkgs,
  ...
}: {
  # Use recursive to allow Noctalia GUI to save settings
  xdg.configFile."noctalia".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home-manager/desktop-shell/noctalia";
}
