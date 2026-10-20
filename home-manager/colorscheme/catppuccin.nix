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
  };

  programs.cava.enable = true;
  programs.obs-studio.enable = true;

  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "kvantum";
  };

  xdg.configFile."mpv/mpv.conf".text = ''
    ${builtins.readFile ../apps/mpv/mpv.conf}
    include=${inputs.catppuccin.packages.${pkgs.system}.sources.mpv}/themes/frappe/blue.conf
  '';
}
