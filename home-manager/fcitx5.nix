# Fcitx5 Vietnamese Input Method (Lotus Engine) Module
{
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = [
        pkgs.fcitx5-lotus
        pkgs.fcitx5-gtk
        pkgs.qt6Packages.fcitx5-configtool
      ];
    };
  };
}
