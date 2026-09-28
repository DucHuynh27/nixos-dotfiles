# MangoWM Configuration Module
{
  config,
  pkgs,
  ...
}: {
  # Symlink mango config file to ~/.config/mango/config.conf
  xdg.configFile."mango/config.conf".source = ./mango/config.conf;
}
