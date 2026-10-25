{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    autoEnable = false;
    flavor = "frappe";
    accent = "blue";

    bat.enable = true;
    cava.enable = true;
    cursors.enable = true;
    eza.enable = true;
    fcitx5.enable = true;
    fzf.enable = true;
    gtk.icon.enable = true;
    kitty.enable = true;
    kvantum.enable = true;
    obs.enable = true;
    starship.enable = true;
    vesktop.enable = true;
    yazi.enable = true;
    zathura.enable = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";

    # Qt6 apps (pcmanfm-qt, LXQt) otherwise fall back to hicolor/oxygen,
    # which has no folder icons. Keep the same Papirus theme as GTK.
    qt6ctSettings = {
      Appearance = {
        icon_theme = "Papirus-Dark";
        style = "kvantum";
      };
    };
    qt5ctSettings = {
      Appearance = {
        icon_theme = "Papirus-Dark";
        style = "kvantum";
      };
    };
  };

  programs.cava.enable = true;
  programs.obs-studio.enable = true;

  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "kvantum";
  };

  xdg.configFile."mpv/mpv.conf".text = ''
    ${builtins.readFile ../apps/mpv/mpv.conf}
    include=${inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.sources.mpv}/themes/frappe/blue.conf
  '';
}
