# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    ./hardware-configuration.nix
    ./damx.nix
    ./databases.nix
    inputs.aagl.nixosModules.default
    {nix.settings = inputs.aagl.nixConfig;}
    inputs.mango.nixosModules.mango
  ];

  aagl.enableNixpkgsReleaseBranchCheck = false;

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = ["nix-command" "flakes"];
      # Opinionated: disable global registry
      flake-registry = "";
      # Optimise storage
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org"
        "https://noctalia.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "noctalia.cachix.org-1:Dr8Vop7J7fhFwzW/LGKsnpUTl/6dHDmQBLRVIoB6a5Q="
      ];
    };
    # Opinionated: disable channels
    # channel.enable = false;
    # Automatic Garbage Collection
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 7d";
    # };
  };

  # Network hostname
  networking.hostName = "nixos";
  programs.umbriel = {
    enable = true;
    package = pkgs.umbriel;
    portalPackage = pkgs.xdg-desktop-portal-umbriel;
  };
  programs.mango.enable = true;
  programs.anime-game-launcher.enable = true;
  programs.sleepy-launcher.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };

  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
      settings = {
        screencast = {
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    config = {
      common.default = "*";
      umbriel = {
        default = ["umbriel" "gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = "umbriel";
        "org.freedesktop.impl.portal.Screenshot" = "umbriel";
        "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
      };
    };
  };
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libglvnd
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  # Bootloader & Secure Boot
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.supportedFilesystems = ["ntfs" "exfat" "vfat" "fat32"];

  # Network
  networking.networkmanager.enable = true;
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = [
        "45.90.28.0#3a3bcb.dns.nextdns.io"
        "2a07:a8c0::#3a3bcb.dns.nextdns.io"
        "45.90.30.0#3a3bcb.dns.nextdns.io"
        "2a07:a8c1::#3a3bcb.dns.nextdns.io"
      ];
      DNSOverTLS = "yes";
      Domains = ["~."];
      FallbackDNS = [];
    };
  };

  # Time zone & Locale
  time.timeZone = "Asia/Ho_Chi_Minh";
  time.hardwareClockInLocalTime = false;
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  fonts.packages = with pkgs; [
    corefonts
  ];

  # Audio
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    extraConfig.pipewire."10-fix-audio" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 1024;
        "default.clock.max-quantum" = 8192;
      };
    };
    wireplumber.extraConfig."50-alsa-suspend" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {"node.name" = "~alsa_card.*";}
            {"node.name" = "~alsa_input.*";}
            {"node.name" = "~alsa_output.*";}
          ];
          actions = {
            update-props = {
              "session.suspend-timeout-seconds" = 0;
              "api.alsa.period-size" = 1024;
              "api.alsa.headroom" = 8192;
            };
          };
        }
      ];
    };
  };

  # Disable audio power saving to prevent stuttering/dropouts
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0 power_save_controller=N enable_msi=1
  '';

  # Nvidia Optimus setup
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    prime = {
      sync.enable = false;
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # NVIDIA HDMI audio shares the memory clock domain with the GPU, so memory
  # clock changes cause brief HDMI audio dropouts. Lock it to keep audio stable.
  systemd.services.nvidia-lock-memclk = {
    description = "Lock NVIDIA GPU memory clock to prevent HDMI audio dropouts";
    wantedBy = ["multi-user.target"];
    after = ["nvidia-persistenced.service"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${lib.getBin config.hardware.nvidia.package}/bin/nvidia-smi --lock-memory-clocks=6001";
    };
  };

  # Wayland / Nvidia environment variables
  environment.sessionVariables = {
    # Hardware cursor is enabled (WLR_NO_HARDWARE_CURSORS removed for smooth high-refresh cursor)
    # WLR_NO_HARDWARE_CURSORS = "1";
    WLR_DRM_NO_ATOMIC = "1";
    NIXOS_OZONE_WL = "1";

    # Prisma NixOS fix: NixOS không có precompiled Prisma engines trên binaries.prisma.sh.
    # Trỏ thẳng đến binary được build bởi nixpkgs thay vì để Prisma tự download.
    PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
  };

  users.users = {
    # FIXME: Replace with your username
    hinne = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = ["i2c" "wheel" "networkmanager" "input" "podman" "kvm" "libvirtd" "video" "render"];
    };
  };

  # Sudo
  security.sudo.extraRules = [
    {
      users = ["hinne"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    ddcutil
    appimage-run
    git
    pkgs.noctalia
    file-roller
    jdk25
    glfw3-minecraft
    quickemu
    quickgui
    virt-viewer
    nest-cli
    efibootmgr
    glib
  ];

  # Enable Zsh
  programs.zsh = {
    enable = true;
  };

  # Allow NixOS to run precompiled binaries (Node.js, JetBrains IDEs, etc.)
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      glib
      libx11
      libxext
      libxi
      libxrender
      libxtst
      libxrandr
      libxcursor
      libxfixes
      libxcomposite
      libxdamage
      libxkbcommon
      wayland
      freetype
      fontconfig
      alsa-lib
      zlib
      libGL
      libsecret
      nss
      nspr
      # Prisma schema-engine cần libssl/libcrypto để chạy
      openssl
    ];
  };

  # Enable nh - Nix cli wrapper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 3d --keep 3";
    flake = "/home/hinne/nix-config";
  };

  # Auto sync bootloader after NixOS garbage collection
  systemd.services.sync-bootloader = {
    description = "Sync bootloader after NixOS garbage collection";
    after = ["nh-clean.service"];
    wants = ["nh-clean.service"];
    wantedBy = ["nh-clean.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/nix/var/nix/profiles/system/bin/switch-to-configuration boot";
    };
  };

  # Enable USB automounting and trash support
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Security
  security.polkit = {
    enable = true;
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.libvirt.unix.manage" &&
            (subject.isInGroup("wheel") || subject.isInGroup("libvirtd"))) {
          return polkit.Result.YES;
        }
      });
    '';
  };
  security.rtkit.enable = true;

  # Bluetooth config (with battery reporting)
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };
  services.blueman.enable = true;
  services.cloudflare-warp.enable = true;

  # Battery and Preformance
  services.upower.enable = true; # Dịch vụ đọc phần trăm pin laptop
  services.power-profiles-daemon.enable = true; # Quản lý chế độ (Tiết kiệm pin / Hiệu năng cao)

  # ZRAM Swap
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;

  # Gaming Optimizations
  programs.gamemode.enable = true;
  programs.steam.enable = true;

  # Virtualisation (Docker, Waydroid & Libvirt/KVM)
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # MChose Mouse Web Driver Udev Rule
  services.udev.packages = with pkgs; [brightnessctl ddcutil];
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="5253", MODE="0666", TAG+="uaccess"
  '';

  # Ollama with Vulkan acceleration for RTX 3050
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
    loadModels = [
      "qwen2.5-coder:7b"
    ];
    environmentVariables = {
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_CONTEXT_LENGTH = "8192";
      OLLAMA_NUM_PARALLEL = "1";
      OLLAMA_MAX_LOADED_MODELS = "1";
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
