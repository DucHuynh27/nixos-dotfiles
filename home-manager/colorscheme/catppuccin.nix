{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  home.activation.installZenCatppuccin = lib.hm.dag.entryAfter ["writeBoundary"] ''
    for profile_root in "$HOME/.config/zen" "$HOME/.zen"; do
      [ -d "$profile_root" ] || continue
      for profile in "$profile_root"/*; do
        [ -d "$profile" ] || continue
        [ -f "$profile/prefs.js" ] || [ -f "$profile/user.js" ] || continue

        mkdir -p "$profile/chrome"
        if [ -f "$profile/chrome/userChrome.css" ] &&
          [ ! -e "$profile/chrome/userChrome.css.pre-catppuccin" ]; then
          cp -p "$profile/chrome/userChrome.css" \
            "$profile/chrome/userChrome.css.pre-catppuccin"
        fi
        if [ -f "$profile/chrome/userContent.css" ] &&
          [ ! -e "$profile/chrome/userContent.css.pre-catppuccin" ]; then
          cp -p "$profile/chrome/userContent.css" \
            "$profile/chrome/userContent.css.pre-catppuccin"
        fi
        install -m 0644 \
          ${inputs.catppuccin-zen-browser}/themes/Mocha/Blue/userChrome.css \
          "$profile/chrome/userChrome.css"
        install -m 0644 \
          ${inputs.catppuccin-zen-browser}/themes/Mocha/Blue/userContent.css \
          "$profile/chrome/userContent.css"
        install -m 0644 \
          ${inputs.catppuccin-zen-browser}/themes/Mocha/Blue/zen-logo-mocha.svg \
          "$profile/chrome/zen-logo-mocha.svg"

        if [ -f "$profile/user.js" ] && ! grep -q \
          '^user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);$' \
          "$profile/user.js"; then
          printf '%s\n' \
            'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' \
            >> "$profile/user.js"
        elif [ ! -f "$profile/user.js" ]; then
          printf '%s\n' \
            'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' \
            > "$profile/user.js"
        fi
      done
    done
  '';

  catppuccin = {
    enable = true;
    autoEnable = false;
    flavor = "mocha";
    accent = "blue";

    cava.enable = true;
    eza.enable = true;
    fcitx5.enable = true;
    fzf.enable = true;
    gtk.icon.enable = true;
    kvantum.enable = true;
    mpv.enable = true;
    obs.enable = true;
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

  home.packages = with pkgs; [
    catppuccin-cursors
    catppuccin-discord
    catppuccin-qt5ct
  ];

  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "kvantum";
  };

  xdg.configFile."mpv/mpv.conf".text = ''
    ${builtins.readFile ../apps/mpv/mpv.conf}
    include=${inputs.catppuccin.packages.${pkgs.system}.sources.mpv}/mocha/blue.conf
  '';
}
