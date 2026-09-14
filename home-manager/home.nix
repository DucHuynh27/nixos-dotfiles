# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./kitty.nix
    ./wezterm.nix
    ./zsh.nix
    ./starship.nix
    ./git.nix
    ./scripts.nix
    ./tools.nix
    ./noctalia.nix
    ./mango.nix
    ./fcitx5.nix
    ./fastfetch.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # TODO: Set your username
  home = {
    username = "hinne";
    homeDirectory = "/home/hinne";
  };

  # Environment Variables
  home.sessionVariables = {
    PNPM_HOME = "$HOME/.local/share/pnpm";
    EDITOR = "nvim";
    TERMINAL = "wezterm";
    BROWSER = "brave";
    LC_MEASUREMENT = "en_IE.UTF-8";
    # Wayland/Qt variables (ported from Niri)
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  # Tạo Desktop Entry đè lên mặc định để sửa lỗi launcher/file search
  xdg.desktopEntries = {
    yazi = {
      name = "Yazi";
      exec = "wezterm -e yazi %u";
      terminal = false;
      categories = ["System" "FileTools" "FileManager" "ConsoleOnly"];
      mimeType = ["inode/directory"];
    };
    nvim = {
      name = "Neovim";
      exec = "wezterm -e nvim %F";
      terminal = false;
      categories = ["Utility" "TextEditor"];
      mimeType = ["text/plain"];
    };
  };

  home.sessionPath = [
    "$HOME/.local/share/pnpm/bin"
    "$HOME/.local/share/pnpm"
    "$HOME/.local/bin"
  ];

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    # ---------------------------------------------------
    # System & Core Tools
    # ---------------------------------------------------
    android-tools
    ansible
    evtest
    htop
    jq
    libnotify
    power-profiles-daemon
    sops
    wl-clipboard
    xdg-utils
    keepassxc
    bilibili
    obs-studio

    # ---------------------------------------------------
    # Desktop Shell & WM
    # ---------------------------------------------------
    bibata-cursors
    linux-wallpaperengine
    matugen
    xwayland-satellite

    # ---------------------------------------------------
    # Shell & CLI Tools
    # ---------------------------------------------------
    wezterm
    fd
    gcc
    gnumake
    nodejs
    pnpm
    ripgrep
    unzip
    yazi

    # ---------------------------------------------------
    # Text Editor & IDE
    # ---------------------------------------------------
    aider-chat
    jetbrains-toolbox
    neovim
    zed-editor

    # ---------------------------------------------------
    # LSPs & Formatters (For Neovim)
    # ---------------------------------------------------
    typescript-language-server
    prettier
    tailwindcss-language-server
    vscode-langservers-extracted
    yaml-language-server
    dockerfile-language-server
    bash-language-server
    nil
    alejandra
    pyright
    isort
    black
    jdt-language-server
    tree-sitter
    lua-language-server

    # ---------------------------------------------------
    # General Apps
    # ---------------------------------------------------
    libreoffice
    localsend
    obsidian
    onlyoffice-desktopeditors
    postman
    telegram-desktop
    vesktop
    inputs.thorium.packages.${pkgs.stdenv.hostPlatform.system}.thorium-avx2
    brave
    kdePackages.okular

    # ---------------------------------------------------
    # Media & Graphics
    # ---------------------------------------------------
    imv
    mpv
    stremio-linux-shell
    upscayl

    # ---------------------------------------------------
    # Screen Toolkit & Capture
    # ---------------------------------------------------
    bc
    gpu-screen-recorder
    gpu-screen-recorder-gtk
    grim
    hyprpicker
    imagemagick
    satty
    slurp
    tesseract
    translate-shell
    wl-screenrec
    zbar

    # ---------------------------------------------------
    # Yazi Plugins & Utilities
    # ---------------------------------------------------
    ffmpeg
    ffmpegthumbnailer
    mediainfo
    p7zip
    poppler-utils
    rich-cli
    unar
    xlsx2csv
    zip
    (python3.withPackages (p: [p.rich p.docx2txt]))

    # ---------------------------------------------------
    # Fonts
    # ---------------------------------------------------
    carlito
    corefonts
    maple-mono.NF
    maple-mono.Normal-NF
    maple-mono.Normal-TTF
    maple-mono.truetype
    nerd-fonts.jetbrains-mono
    vista-fonts

    # ---------------------------------------------------
    # Antigravity CLI
    # ---------------------------------------------------
    inputs.antigravity.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
    opencode
  ];
  # Enable home-manager
  programs.home-manager.enable = true;

  # Automount USB drives
  services.udiskie.enable = true;

  systemd.user.targets.mango-session = {
    Unit = {
      Description = "MangoWM session";
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
    };
  };

  xdg.configFile = {
    "nvim" = {
      source = ./nvim;
      recursive = true;
    };
    "mpv".source = ./mpv;
    "matugen/config.toml".text = ''
      [config]
      wallpaper_dir = "/home/hinne/Pictures/Wallpapers"

      [templates.nvim]
      input_path = "/home/hinne/.config/matugen/templates/nvim.lua"
      output_path = "/home/hinne/.cache/nvim/matugen.lua"

      [templates.kitty]
      input_path = "/home/hinne/.config/matugen/templates/kitty.conf"
      output_path = "/home/hinne/.config/kitty/themes/noctalia.conf"

      [templates.wezterm]
      input_path = "/home/hinne/.config/matugen/templates/wezterm.lua"
      output_path = "/home/hinne/.config/wezterm/colors/noctalia.lua"
    '';
    "matugen/templates/kitty.conf".text = ''
      # Generated by Matugen
      foreground {{colors.on_surface.default.hex}}
      background {{colors.surface.default.hex}}
      selection_foreground {{colors.on_secondary.default.hex}}
      selection_background {{colors.secondary_fixed_dim.default.hex}}
      cursor {{colors.on_surface.default.hex}}
      cursor_text_color {{colors.surface.default.hex}}
      active_tab_foreground {{colors.on_secondary_container.default.hex}}
      active_tab_background {{colors.secondary_container.default.hex}}
      inactive_tab_foreground {{colors.on_surface_variant.default.hex}}
      inactive_tab_background {{colors.surface_container_low.default.hex}}
      active_border_color {{colors.primary.default.hex}}
      inactive_border_color {{colors.outline_variant.default.hex}}

      color0 {{colors.surface.default.hex}}
      color8 {{colors.surface_variant.default.hex}}
      color1 {{colors.error.default.hex}}
      color9 {{colors.error.default.hex}}
      color2 {{colors.primary.default.hex}}
      color10 {{colors.primary.default.hex}}
      color3 {{colors.tertiary.default.hex}}
      color11 {{colors.tertiary.default.hex}}
      color4 {{colors.secondary.default.hex}}
      color12 {{colors.secondary.default.hex}}
      color5 {{colors.primary.default.hex}}
      color13 {{colors.primary.default.hex}}
      color6 {{colors.secondary.default.hex}}
      color14 {{colors.secondary.default.hex}}
      color7 {{colors.on_surface.default.hex}}
      color15 {{colors.on_surface.default.hex}}
    '';
    "matugen/templates/nvim.lua".text = ''
      require('base16-colorscheme').setup({
        base00 = '{{colors.surface.default.hex}}',
        base01 = '{{colors.surface_dim.default.hex}}',
        base02 = '{{colors.surface_container.default.hex}}',
        base03 = '{{colors.outline_variant.default.hex}}',
        base04 = '{{colors.outline.default.hex}}',
        base05 = '{{colors.on_surface_variant.default.hex}}',
        base06 = '{{colors.on_surface.default.hex}}',
        base07 = '{{colors.on_surface.default.hex}}',
        base08 = '{{colors.error.default.hex}}',
        base09 = '{{colors.tertiary.default.hex}}',
        base0A = '{{colors.primary.default.hex}}',
        base0B = '{{colors.secondary.default.hex}}',
        base0C = '{{colors.tertiary.default.hex}}',
        base0D = '{{colors.primary.default.hex}}',
        base0E = '{{colors.secondary.default.hex}}',
        base0F = '{{colors.error.default.hex}}',
      })
      local hi = function(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
      end

      -- Enable Transparency to seamlessly match Kitty's background
      hi('Normal', { bg = 'NONE' })
      hi('NormalNC', { bg = 'NONE' })
      hi('SignColumn', { bg = 'NONE' })
      hi('EndOfBuffer', { bg = 'NONE' })
      hi('NeoTreeNormal', { bg = 'NONE' })
      hi('NeoTreeNormalNC', { bg = 'NONE' })
      hi('NeoTreeWinSeparator', { fg = '{{colors.outline_variant.default.hex}}', bg = 'NONE' })
      hi('WinSeparator', { fg = '{{colors.outline_variant.default.hex}}', bg = 'NONE' })
      hi('NormalFloat', { bg = 'NONE' })
      hi('FloatBorder', { bg = 'NONE' })
      hi('LazyNormal', { bg = 'NONE' })
      hi('MasonNormal', { bg = 'NONE' })

      hi('TelescopeNormal',         { fg = '{{colors.on_surface.default.hex}}', bg = 'NONE' })
      hi('TelescopeBorder',         { fg = '{{colors.outline_variant.default.hex}}', bg = 'NONE' })
      hi('TelescopePromptNormal',   { fg = '{{colors.on_surface.default.hex}}', bg = 'NONE' })
      hi('TelescopePromptBorder',   { fg = '{{colors.outline_variant.default.hex}}', bg = 'NONE' })
      hi('TelescopePromptPrefix',   { fg = '{{colors.primary.default.hex}}', bg = 'NONE' })
      hi('TelescopePromptCounter',  { fg = '{{colors.outline.default.hex}}', bg = 'NONE' })
      hi('TelescopePromptTitle',    { fg = '{{colors.surface.default.hex}}', bg = '{{colors.primary.default.hex}}' })
      hi('TelescopePreviewTitle',   { fg = '{{colors.surface.default.hex}}', bg = '{{colors.secondary.default.hex}}' })
      hi('TelescopeResultsTitle',   { fg = '{{colors.surface.default.hex}}', bg = '{{colors.tertiary.default.hex}}' })
      hi('TelescopeSelection',      { fg = '{{colors.on_surface.default.hex}}', bg = '{{colors.surface_container.default.hex}}' })
      hi('TelescopeSelectionCaret', { fg = '{{colors.primary.default.hex}}', bg = '{{colors.surface_container.default.hex}}' })
      hi('TelescopeMatching',       { fg = '{{colors.primary.default.hex}}', bold = true })
    '';
    "matugen/templates/wezterm.lua".text = ''
      return {
        foreground = '{{colors.on_surface.default.hex}}',
        background = '{{colors.surface.default.hex}}',
        cursor_bg = '{{colors.on_surface.default.hex}}',
        cursor_fg = '{{colors.surface.default.hex}}',
        cursor_border = '{{colors.on_surface.default.hex}}',
        selection_fg = '{{colors.on_secondary.default.hex}}',
        selection_bg = '{{colors.secondary_fixed_dim.default.hex}}',

        tab_bar = {
          background = '{{colors.surface_container_low.default.hex}}',
          active_tab = {
            bg_color = '{{colors.secondary_container.default.hex}}',
            fg_color = '{{colors.on_secondary_container.default.hex}}',
          },
          inactive_tab = {
            bg_color = '{{colors.surface_container_low.default.hex}}',
            fg_color = '{{colors.on_surface_variant.default.hex}}',
          },
        },

        ansi = {
          '{{colors.surface.default.hex}}',
          '{{colors.error.default.hex}}',
          '{{colors.primary.default.hex}}',
          '{{colors.tertiary.default.hex}}',
          '{{colors.primary.default.hex}}',
          '{{colors.secondary.default.hex}}',
          '{{colors.secondary.default.hex}}',
          '{{colors.on_surface.default.hex}}',
        },
        brights = {
          '{{colors.surface_variant.default.hex}}',
          '{{colors.error.default.hex}}',
          '{{colors.primary.default.hex}}',
          '{{colors.tertiary.default.hex}}',
          '{{colors.primary.default.hex}}',
          '{{colors.secondary.default.hex}}',
          '{{colors.secondary.default.hex}}',
          '{{colors.on_surface.default.hex}}',
        },
      }
    '';
  };

  # Sops-Nix configuration for secrets
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt"; # Phải trỏ đúng file chứa key
    defaultSopsFile = ../secrets/secrets.yaml;
    secrets."ssh_key" = {
      path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    };
  };

  # Default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/about" = "brave-browser.desktop";
      "x-scheme-handler/unknown" = "brave-browser.desktop";

      # Documents
      "application/pdf" = "org.kde.okular.desktop";

      # File Manager
      "inode/directory" = "yazi.desktop";

      # Image Viewer
      "image/jpeg" = "imv.desktop";
      "image/png" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "image/webp" = "imv.desktop";

      # Video Player
      "video/mp4" = "mpv.desktop";
      "video/mkv" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/webm" = "mpv.desktop";

      # Text Editor
      "text/plain" = "nvim.desktop";
      "text/markdown" = "nvim.desktop";
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 28;
    gtk.enable = true;
    x11.enable = true;
  };

  home.stateVersion = "25.11";
  news.display = "silent";

  # Enable font discovery for home-manager fonts
  fonts.fontconfig.enable = true;

  xdg.configFile."fontconfig/conf.d/99-maple-mono-features.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <match target="font">
        <test name="family" compare="contains">
          <string>Maple Mono</string>
        </test>
        <edit name="fontfeatures" mode="append">
          <string>cv01 on</string>
          <string>cv03 on</string>
          <string>cv06 on</string>
          <string>cv09 on</string>
          <string>cv32 on</string>
          <string>cv42 on</string>
          <string>cv61 on</string>
          <string>cv66 on</string>
          <string>zero on</string>
        </edit>
      </match>
    </fontconfig>
  '';
}
