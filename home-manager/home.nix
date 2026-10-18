# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  # The current nixpkgs source has a stale fixed-output hash for this package.
  # Keep the package available while using the hash produced by its locked source.
  typescript-language-server = pkgs.typescript-language-server.overrideAttrs (old: {
    pnpmDeps = old.pnpmDeps.overrideAttrs (_: {
      outputHash = "sha256-xR/EF60lVBsITKgH7wCM2wHM46PFQevD51KfCENSUH4=";
    });
  });
in {
  # You can import other home-manager modules here
  imports = [
    # Colorscheme
    ./colorscheme/catppuccin.nix

    # TUI & Shell
    ./tui/aider.nix
    ./tui/lgtm.nix
    ./tui/wezterm.nix
    ./tui/zsh.nix
    ./tui/starship.nix
    ./tui/git.nix
    ./tui/scripts.nix
    ./tui/tools.nix
    ./tui/fastfetch.nix

    # Apps
    ./apps/mangohud.nix
    ./apps/zathura.nix

    # Window Manager
    ./wm/mango.nix
    ./wm/umbriel.nix

    # Desktop Shell & UI
    inputs.look.homeModules.default
    ./desktop-shell/wayle.nix
    ./desktop-shell/noctalia.nix

    # Editors
    ./editors/VSCode/vscode.nix

    # System & Input
    ./system/fcitx5.nix
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
    BROWSER = "zen";
    LC_MEASUREMENT = "en_IE.UTF-8";
    # Wayland/Qt variables (ported from Niri)
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    DEEPSEEK_API_KEY_FILE = "${config.home.homeDirectory}/.config/secrets/deepseek-api-key";
    DOCKER_HOST = "unix:///run/podman/podman.sock";
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
    concord-tui = {
      name = "Concord TUI";
      exec = "concord-tui-wezterm";
      terminal = false;
      categories = ["Network" "Chat" "ConsoleOnly"];
    };
  };

  home.sessionPath = [
    "$HOME/.local/share/pnpm/bin"
    "$HOME/.local/share/pnpm"
    "$HOME/.local/bin"
  ];

  programs.lookapp = {
    enable = true;
    settings = {
      launcher_hotkey = "none";
    };
  };

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
    sops
    wl-clipboard
    xdg-utils
    keepassxc
    clipse
    flameshot
    podman-compose

    # ---------------------------------------------------
    # Desktop Shell & WM
    # ---------------------------------------------------
    bibata-cursors
    linux-wallpaperengine
    matugen
    xwayland-satellite
    wlr-randr

    # ---------------------------------------------------
    # Shell & CLI Tools
    # ---------------------------------------------------
    fd
    gcc
    gnumake
    lazydocker
    lazygit
    nodejs
    pnpm
    ripgrep
    unzip
    posting

    # ---------------------------------------------------
    # Text Editor & IDE
    # ---------------------------------------------------
    pkgs.jetbrains-toolbox
    neovim

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
    stylua
    prettierd

    # ---------------------------------------------------
    # General Apps
    # ---------------------------------------------------
    libreoffice
    localsend
    obsidian
    postman
    pcmanfm-qt
    lxqt.lxqt-archiver
    telegram-desktop
    vesktop
    wpsoffice
    inputs.thorium.packages.${pkgs.stdenv.hostPlatform.system}.thorium-avx2
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    texlab
    (texliveMedium.withPackages (ps:
      with ps; [
        scheme-medium # Gói nền tảng: ĐÃ BAO GỒM xetex, fontspec, geometry, setspace, indentfirst, graphics (chứa graphicx), hyperref, latexmk, v.v.
        titlesec # Thêm riêng package format tiêu đề để đảm bảo chắc chắn
      ]))
    bilibili

    # ---------------------------------------------------
    # Media & Graphics
    # ---------------------------------------------------
    imv
    mpv
    stremio-linux-shell
    upscayl
    inputs.sonora.packages.${pkgs.stdenv.hostPlatform.system}.sonora-bin

    # ---------------------------------------------------
    # Screen Toolkit & Capture
    # ---------------------------------------------------
    bc
    grim
    hyprpicker
    imagemagick
    satty
    slurp
    tesseract
    translate-shell
    wl-screenrec
    zbar
    zenity

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
    (python3.withPackages (p:
      with p; [
        rich
        docx2txt
        wand
        win2xcur
        matplotlib
        numpy
      ]))

    # ---------------------------------------------------
    # Fonts
    # ---------------------------------------------------
    carlito
    ibm-plex
    nerd-fonts.jetbrains-mono
    vista-fonts

    # ---------------------------------------------------
    # Antigravity CLI & Apps
    # ---------------------------------------------------
    inputs.antigravity.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
    inputs.serein.packages.${pkgs.stdenv.hostPlatform.system}.default
    opencode

    # ---------------------------------------------------
    # Overrides & Fixes
    # ---------------------------------------------------
  ];
  # Enable home-manager
  programs.home-manager.enable = true;

  # Automount USB drives
  services.udiskie.enable = true;

  xdg.configFile = {
    "concord/config.toml" = {
      force = true;
      text = ''
        [display]
        disable_image_preview = false
        show_avatars = true
        show_images = true
        media_playback = true
        image_preview_quality = "high"
        attachment_viewer_quality = "original"
        image_protocol = "auto"
        animate_previews = "always"
        show_custom_emoji = true
        circular_avatars = false
        hour_format_24 = true

        [composer]
        emojis_as_links = true
        ping_on_reply = true

        [presence]
        share_rich_presence = false

        [translation]
        provider = "deepl"
        endpoint = "https://api-free.deepl.com/v2/translate"
        message_target_language = "VI"
        composer_target_language = "EN"
        api_key_env = "DEEPL_API_KEY"
      '';
    };
    "clipse/config.json" = {
      source = ./apps/clipse/config.json;
      force = true;
    };
    "clipse/catppuccin-mocha-blue.json" = {
      source = "${inputs.catppuccin-clipse}/themes/mocha/catppuccin-mocha-blue.json";
      force = true;
    };
    "flameshot/flameshot.ini" = {
      source = ./apps/flameshot/flameshot.ini;
      force = true;
    };
    "nvim" = {
      source = ./editors/nvim;
      recursive = true;
    };
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
    secrets."deepseek_api_key" = {
      path = "${config.home.homeDirectory}/.config/secrets/deepseek-api-key";
    };
    secrets."deepl_api_key" = {
      path = "${config.home.homeDirectory}/.config/secrets/deepl-api-key";
    };
  };

  # Default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";

      # Documents & Office
      "application/pdf" = "draw.desktop";
      "application/msword" = "wps-office-wps.desktop";
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "wps-office-wps.desktop";
      "application/vnd.oasis.opendocument.text" = "writer.desktop";
      "application/rtf" = "wps-office-wps.desktop";
      "application/vnd.ms-excel" = "wps-office-et.desktop";
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "wps-office-et.desktop";
      "application/vnd.oasis.opendocument.spreadsheet" = "calc.desktop";
      "text/csv" = "wps-office-et.desktop";
      "application/vnd.ms-powerpoint" = "wps-office-wpp.desktop";
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "wps-office-wpp.desktop";
      "application/vnd.oasis.opendocument.presentation" = "impress.desktop";

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

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-im-module = "fcitx";
    };
    gtk4.extraConfig = {
      gtk-im-module = "fcitx";
    };
  };

  home.stateVersion = "25.11";
  news.display = "silent";

  # Enable font discovery for home-manager fonts
  fonts.fontconfig.enable = true;

  xdg.configFile."fontconfig/conf.d/10-custom-fonts.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <dir>/home/hinne/.local/share/fonts</dir>
      <dir>~/.local/share/fonts</dir>
      <dir>~/.fonts</dir>
    </fontconfig>
  '';

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
